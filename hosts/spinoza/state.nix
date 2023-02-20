{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    hideMounts = true;
    directories = [
      "/var/cache/powertop"
      "/var/lib/bluetooth"
      "/var/lib/boltd"
      "/var/lib/fwupd"
      "/var/lib/fprint"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/var/lib/tailscale"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nix/tokens.conf"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    users.bemeurer = {
      directories = [
        ".aws"
        ".cache/chromium"
        ".cache/direnv"
        ".cache/lollypop"
        ".cache/mozilla"
        ".cache/nix"
        ".cache/nix-index"
        ".cache/nvim"
        ".cache/Plexamp"
        ".cache/thunderbird"
        ".cache/wofi"
        ".cache/zsh"
        ".config/1Password"
        ".config/chromium"
        ".config/dconf"
        ".config/deluge"
        ".config/discord"
        ".config/Element"
        ".config/gcloud"
        ".config/Ledger Live"
        ".config/libvirt"
        ".config/Mullvad VPN"
        ".config/op"
        ".config/pipewire"
        ".config/Plexamp"
        ".config/Signal"
        ".config/TabNine"
        ".config/Yubico"
        ".local/share/atuin"
        ".local/share/bash"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/iwctl"
        ".local/share/libvirt"
        ".local/share/lollypop"
        ".local/share/nvim"
        ".local/share/Plexamp"
        ".local/share/TabNine"
        ".local/share/zsh"
        ".mozilla"
        ".thunderbird"
        "doc"
        "img"
        "opt"
        "src"
        "tmp"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
      files = [
        ".config/cachix/cachix.dhall"
        ".config/gh/hosts.yml"
        ".local/share/wall.png"
      ];
    };
  };
}
