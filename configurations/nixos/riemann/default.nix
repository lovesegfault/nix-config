# Raspberry Pi 5 driving the Voron 2.4 (LDO Leviathan v1.3 + extension board).
#
# Boots from SD via the Pi firmware -> U-Boot -> extlinux.conf, so NixOS
# generations show up in the U-Boot menu and rollbacks work. Build the image with
#   nix build .#nixosConfigurations.riemann.config.system.build.sdImage
{
  flake,
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-5

    # Internal modules via flake outputs
    self.nixosModules.default
    self.nixosModules.users-bemeurer
  ];

  # Platform
  nixpkgs.hostPlatform = "aarch64-linux";

  # Host-specific configuration
  boot = {
    # No TPM on the Pi 5, and the vendor kernel has no ACPI, so the tpm-crb
    # module this pulls into the initrd doesn't exist.
    initrd.systemd.tpm2.enable = false;
    kernelParams = [
      # The vendor defconfig sets PSI_DEFAULT_DISABLED, which breaks systemd-oomd.
      "psi=1"
      # Pi 5 debug UART (3-pin JST between the HDMI ports), then HDMI.
      "console=ttyAMA10,115200"
      "console=tty0"
    ];
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxIQV5CtcR4kXrAC5sTw7OyyoYdOzVXnc5UPrM2TQSy";

  fileSystems = {
    # btrfs with zstd:1 benchmarked best on the SD card: ~1.5x faster store
    # writes and ~2x faster cold reads than ext4, and near-instant deletes.
    # sd-image.nix hardcodes ext4.
    "/" = {
      fsType = lib.mkForce "btrfs";
      options = [
        "noatime"
        "compress=zstd:1"
      ];
    };
    # sd-image.nix mounts this noauto; mount it so the firmware activation
    # script below can keep config.txt, U-Boot and the DTBs in sync on every
    # switch.
    "/boot/firmware".options = lib.mkForce [
      "nofail"
      "noatime"
    ];
  };

  hardware = {
    # sd-image.nix turns this on, which drags in initrd modules the vendor
    # kernel doesn't build.
    enableAllHardware = lib.mkForce false;
    # Trickle-charge the official (rechargeable ML-2020) RTC battery at 3.0V;
    # the Pi 5 leaves charging off by default. Never set this for a CR2032.
    raspberry-pi.configtxt.settings.pi5.dtparam = [ "rtc_bbat_vchg=3000000" ];
    raspberry-pi.firmware = {
      enable = true;
      # The Pi 5 keeps its GPU firmware in the bootloader EEPROM, so the
      # start*.elf/fixup*.dat/bootcode.bin blobs for older boards are ~22 MiB
      # of dead weight on the 30 MiB firmware partition, enough that the
      # sync's temp copies ran it out of space. Ship only what the Pi 5 reads,
      # plus bootcode.bin (52K), which the sync script copies unconditionally.
      package = pkgs.runCommand "raspberrypifw-pi5" { } ''
        boot=$out/share/raspberrypi/boot
        mkdir -p $boot
        cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/{bcm2712*.dtb,overlays,bootcode.bin} $boot/
      '';
      uboot = {
        enable = true;
        # U-Boot reads extlinux.conf, the kernel and the initrd straight off
        # the btrfs root, and rpi_arm64_defconfig only builds ext4/FAT.
        # FS_BTRFS pulls in zstd, which the compressed extents need.
        package = pkgs.ubootRaspberryPiAarch64.override {
          extraConfig = ''
            CONFIG_FS_BTRFS=y
            CONFIG_CMD_BTRFS=y
          '';
        };
      };
    };
  };

  networking = {
    hostId = "db6e0940";
    hostName = "riemann";
    wireless.iwd.enable = true;
  };

  nix.gc = {
    automatic = true;
    options = "-d";
  };

  # The RTC battery keeps time across power-offs, but if it ever runs flat the
  # Pi boots with a stale clock, DNSSEC rejects every signature as expired, and
  # NTP can't resolve its servers to fix the clock.
  services.resolved.settings.Resolve.DNSSEC = lib.mkForce "false";

  sdImage = {
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    # nixpkgs' btrfs creator needs two fixes to its mkfs.btrfs call:
    # - It doesn't compress what it bakes into the image; use the same
    #   compression as the mount.
    # - It runs mkfs.btrfs under fakeroot, which mkfs.btrfs sees straight
    #   through, so every file lands owned by the build sandbox user (uid
    #   1000) and systemd-tmpfiles then refuses to create anything under /.
    #   A user namespace that maps the build user to root gets real uid 0.
    rootFilesystemImage =
      let
        image = pkgs.callPackage "${modulesPath}/../lib/make-btrfs-fs.nix" {
          inherit (config.sdImage) storePaths compressImage;
          populateImageCommands = config.sdImage.populateRootCommands;
          volumeLabel = config.sdImage.rootVolumeLabel;
        };
        fixes = {
          "fakeroot mkfs.btrfs" = "unshare --map-root-user mkfs.btrfs";
          " --shrink " = " --shrink --compress zstd:1 ";
        };
        missing = builtins.filter (from: !lib.hasInfix from image.buildCommand) (builtins.attrNames fixes);
      in
      assert lib.assertMsg (
        missing == [ ]
      ) "make-btrfs-fs.nix changed, these patch targets are gone: ${toString missing}";
      image.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.buildPackages.util-linux ];
        buildCommand =
          builtins.replaceStrings (builtins.attrNames fixes) (builtins.attrValues fixes)
            old.buildCommand;
      });
  };

  # sd-image.nix grows the root with resize2fs, which only knows ext4.
  systemd.services.expand-root-partition.script = lib.mkForce ''
    rootPart=$(${lib.getExe' pkgs.util-linux "findmnt"} -n -o SOURCE /)
    bootDevice=$(${lib.getExe' pkgs.util-linux "lsblk"} -npo PKNAME $rootPart)
    partNum=$(${lib.getExe' pkgs.util-linux "lsblk"} -npo MAJ:MIN $rootPart | ${lib.getExe pkgs.gawk} -F: '{print $2}')

    echo ",+," | ${lib.getExe' pkgs.util-linux "sfdisk"} -N$partNum --no-reread $bootDevice
    ${lib.getExe' pkgs.parted "partprobe"}
    ${lib.getExe' pkgs.btrfs-progs "btrfs"} filesystem resize max /
  '';

  # TODO: pin these to MACAddress like the other hosts once the board is up.
  systemd.network.networks = {
    eth = {
      DHCP = "yes";
      matchConfig.Type = "ether";
      dhcpV4Config.RouteMetric = 10;
      ipv6AcceptRAConfig.RouteMetric = 10;
      networkConfig.MulticastDNS = true;
    };
    wifi = {
      DHCP = "yes";
      matchConfig.Type = "wlan";
      dhcpV4Config.RouteMetric = 40;
      ipv6AcceptRAConfig.RouteMetric = 40;
      networkConfig.MulticastDNS = true;
    };
  };

  time.timeZone = "America/New_York";
}
