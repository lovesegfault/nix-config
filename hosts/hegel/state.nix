{
  age.identityPaths = [ "/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/state" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/var/lib/syncthing"
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
        ".cache/lollypop"
        ".cache/mozilla"
        ".cache/nix-index"
        ".cache/nvim"
        ".cache/shotwell"
        ".cache/thunderbird"
        ".cache/wofi"
        ".cache/zoom"
        ".cache/zsh"
        ".config/Element"
        ".config/Signal"
        ".config/Slack"
        ".config/TabNine"
        ".config/coc"
        ".config/cog"
        ".config/dconf"
        ".config/discord"
        ".config/gcloud"
        ".config/gopass"
        ".config/pipewire"
        ".config/shotwell"
        ".gsutil"
        ".local/share/Steam"
        ".local/share/TabNine"
        ".local/share/bash"
        ".local/share/direnv"
        ".local/share/iwctl"
        ".local/share/lollypop"
        ".local/share/nvim"
        ".local/share/shotwell"
        ".local/share/zsh"
        ".mozilla"
        ".thunderbird"
        ".zoom"
        "documents"
        "opt"
        "src"
        "tmp"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
        { directory = ".password-store"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
      files = [
        ".arcrc"
        ".cache/cargo/credentials"
        ".config/cachix/cachix.dhall"
        ".config/gh/hosts.yml"
        ".config/zoomus.conf"
        ".gist-vim"
        ".local/share/wall.png"
        ".vault-token"
      ];
    };
  };
}
