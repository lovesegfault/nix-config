{ lib, pkgs, ... }: {
  imports = [
    ../../core
    ../../core/unbound.nix

    ../../dev
    ../../dev/stcg-gcs
    ../../dev/stcg-cameras.nix
    ../../dev/qemu.nix
    ../../dev/virt-manager.nix

    ../../hardware/nixos-aarch64-builder
    ../../hardware/thinkpad-p1.nix
    ../../hardware/yubikey.nix
    ../../hardware/zfs.nix

    ../../sway
    ../../sway/trusted.nix

    ../../users/bemeurer
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    initrd.availableKernelModules = [ "thunderbolt" "amdgpu" ];
    kernelParams = [ "fbcon=map:1" ];
  };

  environment.systemPackages = with pkgs; [ cntr ];

  environment.persistence."/state" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/boltd"
      "/var/lib/docker"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/var/lib/tailscale"

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
      "/home/bemeurer/.config/shotwell"
      "/home/bemeurer/.gnupg"
      "/home/bemeurer/.gsutil"
      "/home/bemeurer/.local/share/Steam"
      "/home/bemeurer/.local/share/TabNine"
      "/home/bemeurer/.local/share/bash"
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
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/17FB-AAD0";
      fsType = "vfat";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/srv/music" = {
      device = "rpool/safe/music";
      fsType = "zfs";
    };
    "/srv/pictures" = {
      device = "rpool/safe/pictures";
      fsType = "zfs";
    };
    "/state" = {
      device = "rpool/safe/state";
      fsType = "zfs";
      neededForBoot = true;
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
  };

  networking = {
    hostName = "foucault";
    hostId = "872516b8";
    wireless.iwd.enable = true;
    networkmanager.enable = lib.mkForce false;
  };

  programs.steam.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    logind.lidSwitchExternalPower = "ignore";
    udev.packages = with pkgs; [ logitech-udev-rules ];
    usbmuxd.enable = true;
  };

  systemd.network.networks = {
    lan = {
      DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
    };
    wifi = {
      DHCP = "yes";
      matchConfig.MACAddress = "98:3b:8f:cf:62:82";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/840591d3-ac66-4137-bc39-4d9f9109c19a"; }];

  time.timeZone = "America/Los_Angeles";
}
