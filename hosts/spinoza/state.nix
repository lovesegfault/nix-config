{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/fwupd"
      "/var/lib/fprint"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/var/lib/tailscale"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    users.bemeurer = {
      directories = [
        ".aws"
        ".cache/darktable"
        ".cache/direnv"
        ".cache/lollypop"
        ".cache/mozilla"
        ".cache/nix"
        ".cache/nix-index"
        ".cache/nvim"
        ".cache/thunderbird"
        ".cache/wofi"
        ".cache/zsh"
        ".config/1Password"
        ".config/Element"
        ".config/Ledger Live"
        ".config/Signal"
        ".config/TabNine"
        ".config/darktable"
        ".config/dconf"
        ".config/discord"
        ".config/gcloud"
        ".config/libvirt"
        ".config/op"
        ".config/pipewire"
        ".local/share/TabNine"
        ".local/share/atuin"
        ".local/share/bash"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/iwctl"
        ".local/share/libvirt"
        ".local/share/lollypop"
        ".local/share/nvim"
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
