{ config, lib, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../dev
    ../../dev/stcg-cameras.nix
    ../../dev/stcg-gcs
    ../../dev/virt-manager.nix

    ../../hardware/bluetooth.nix
    ../../hardware/efi.nix
    ../../hardware/nixos-aarch64-builder
    ../../hardware/sound-pulse.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../sway
    ../../sway/trusted.nix

    ../../users/bemeurer
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/local/root@blank
      '';
    };
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" "ddcci-backlight" "i2c-dev" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.persistence."/state" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/var/lib/tailscale"
      "/var/log"

      "/home/bemeurer/.cache/lollypop"
      "/home/bemeurer/.cache/mozilla"
      "/home/bemeurer/.cache/nvim"
      "/home/bemeurer/.cache/shotwell"
      "/home/bemeurer/.cache/thunderbird"
      "/home/bemeurer/.cache/zoom"
      "/home/bemeurer/.cache/zsh"
      "/home/bemeurer/.config/Slack"
      "/home/bemeurer/.config/TabNine"
      "/home/bemeurer/.config/coc"
      "/home/bemeurer/.config/cog"
      "/home/bemeurer/.config/dconf"
      "/home/bemeurer/.config/discord"
      "/home/bemeurer/.config/gcloud"
      "/home/bemeurer/.config/gopass"
      "/home/bemeurer/.config/pipewire"
      "/home/bemeurer/.config/shotwell"
      "/home/bemeurer/.gnupg"
      "/home/bemeurer/.gsutil"
      "/home/bemeurer/.local/share/Steam"
      "/home/bemeurer/.local/share/TabNine"
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/direnv"
      "/home/bemeurer/.local/share/iwctl"
      "/home/bemeurer/.local/share/keyrings"
      "/home/bemeurer/.local/share/lollypop"
      "/home/bemeurer/.local/share/nvim"
      "/home/bemeurer/.local/share/shotwell"
      "/home/bemeurer/.local/share/zsh"
      "/home/bemeurer/.mozilla"
      "/home/bemeurer/.password-store"
      "/home/bemeurer/.ssh"
      "/home/bemeurer/.thunderbird"
      "/home/bemeurer/.zoom"
      "/home/bemeurer/documents"
      "/home/bemeurer/opt"
      "/home/bemeurer/src"
      "/home/bemeurer/tmp"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  fileSystems = {
    "/" = {
      device = "zroot/local/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/754E-45C0";
      fsType = "vfat";
    };
    "/nix" = {
      device = "zroot/local/nix";
      fsType = "zfs";
    };
    "/srv/music" = {
      device = "zroot/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "zroot/safe/pictures";
      fsType = "zfs";
    };
    "/state" = {
      device = "zroot/safe/state";
      fsType = "zfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    brillo.enable = true;
    i2c.enable = true;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    };
  };

  home-manager.users.bemeurer = { ... }: {
    imports = [
      ../../users/bemeurer/music
      ../../users/bemeurer/trusted
    ];
    home.persistence."/state/home/bemeurer" = {
      allowOther = true;
      files = [
        ".arcrc"
        ".cache/.sway-launcher-desktop-wrapped-history.txt"
        ".cache/cargo/credentials"
        ".config/beets/config.yaml"
        ".config/cachix/cachix.dhall"
        ".config/gh/hosts.yml"
        ".config/zoomus.conf"
        ".gist-vim"
        ".newsboat/cache.db"
        ".newsboat/history.search"
        ".vault-token"
        ".wall"
      ];
    };

    wayland.windowManager.sway = {
      config = {
        input = {
          "10730:258:Kinesis_Advantage2_Keyboard" = {
            xkb_layout = "us";
          };

          "1133:16511:Logitech_G502" = {
            accel_profile = "adaptive";
            natural_scroll = "enabled";
          };

          "1133:16495:Logitech_MX_Ergo" = {
            accel_profile = "adaptive";
            natural_scroll = "enabled";
          };

          "1133:45085:Logitech_MX_Ergo_Multi-Device_Trackball" = {
            accel_profile = "adaptive";
            natural_scroll = "enabled";
          };
        };
        output = {
          "Goldstar Company Ltd LG Ultra HD 0x00000B08" = {
            adaptive_sync = "on";
            mode = "3840x2160@60Hz";
            position = "0,720";
            subpixel = "rgb";
          };
          "Goldstar Company Ltd LG Ultra HD 0x00009791" = {
            adaptive_sync = "on";
            mode = "3840x2160@60Hz";
            position = "3840,0";
            subpixel = "rgb";
            transform = "270";
          };
        };
      };
      extraConfig = ''
        focus output DP-1
        workspace 0:α
      '';
    };
  };

  networking = {
    hostId = "872516b8";
    hostName = "hegel";
    networkmanager.enable = lib.mkForce false;
    wireguard.enable = true;
    wireless.iwd.enable = true;
  };

  nix.maxJobs = 32;

  programs.steam.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fwupd.enable = true;
    ratbagd.enable = true;
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "3c:7c:3f:21:80:67";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "c8:e2:65:0a:7e:d1";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e4103056-9ef2-47da-8403-46cf20541b15"; }
    { device = "/dev/disk/by-uuid/4b74d5bd-3e62-4077-a126-6d73ad07267f"; }
  ];

  time.timeZone = "America/Los_Angeles";

  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
  };
}
