{ lib, pkgs, ... }: {
  imports = [
    (import ../nix).impermanence
    ../core

    ../dev
    ../dev/stcg-gcs.nix
    ../dev/stcg-cameras.nix
    ../dev/stcg-aarch64-builder.nix
    ../dev/qemu.nix
    ../dev/virt-manager.nix

    ../hardware/thinkpad-p1.nix
    ../hardware/yubikey.nix
    ../hardware/zfs.nix

    ../sway
    ../sway/trusted.nix

    ../users/bemeurer
  ];

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

  environment.impermanence."/state" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/nixus-secrets"
    ] ++ [
      "/home/bemeurer/.cache/lollypop"
      "/home/bemeurer/.cache/mozilla"
      "/home/bemeurer/.cache/nix"
      "/home/bemeurer/.cache/nvim"
      "/home/bemeurer/.cache/shotwell"
      "/home/bemeurer/.cache/thunderbird"
      "/home/bemeurer/.cache/zoom"
      "/home/bemeurer/.config/Slack"
      "/home/bemeurer/.config/dconf"
      "/home/bemeurer/.config/discord"
      "/home/bemeurer/.config/gcloud"
      "/home/bemeurer/.config/gopass"
      "/home/bemeurer/.config/shotwell"
      "/home/bemeurer/.gnupg/private-keys-v1.d"
      "/home/bemeurer/.gsutil"
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/keyrings"
      "/home/bemeurer/.local/share/lollypop"
      "/home/bemeurer/.local/share/nix"
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
    ] ++ [
      "/home/bemeurer/.arcrc"
      "/home/bemeurer/.cache/swaymenu-history.txt"
      "/home/bemeurer/.config/zoomus.conf"
      "/home/bemeurer/.gist"
      "/home/bemeurer/.gist-vim"
      "/home/bemeurer/.gnupg/pubring.kbx"
      "/home/bemeurer/.gnupg/random_seed"
      "/home/bemeurer/.gnupg/sshcontrol"
      "/home/bemeurer/.gnupg/trustdb.gpg"
      "/home/bemeurer/.newsboat/cache.db"
      "/home/bemeurer/.newsboat/history.search"
      "/home/bemeurer/.wall"
    ];
  };

  hardware.logitech.enable = true;

  networking = {
    hostName = "foucault";
    hostId = "872516b8";
    wireless.iwd.enable = true;
  };

  programs.geary.enable = true;

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services.keybase.enable = false;

  systemd.network = {
    links.enp0s31f6 = {
      linkConfig.MTUBytes = "9000";
      matchConfig.MACAddress = "48:2a:e3:61:39:66";
    };
    networks = {
      lan = {
        DHCP = "ipv4";
        linkConfig = {
          MTUBytes = "9000";
          RequiredForOnline = "no";
        };
        matchConfig.MACAddress = "48:2a:e3:61:39:66";
      };
      wifi = {
        DHCP = "yes";
        matchConfig.MACAddress = "98:3b:8f:cf:62:82";
      };
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/840591d3-ac66-4137-bc39-4d9f9109c19a"; }];

  time.timeZone = "America/Los_Angeles";
}
