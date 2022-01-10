{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/boltd"
      "/var/lib/docker"
      "/var/lib/iwd"
      "/var/lib/fwupd"
      "/var/lib/tailscale"
      "/var/log"

      "/home/bemeurer/.cache/direnv"
      "/home/bemeurer/.cache/lollypop"
      "/home/bemeurer/.cache/mozilla"
      "/home/bemeurer/.cache/nix"
      "/home/bemeurer/.cache/nix-index"
      "/home/bemeurer/.cache/nvim"
      "/home/bemeurer/.cache/shotwell"
      "/home/bemeurer/.cache/thunderbird"
      "/home/bemeurer/.cache/wofi"
      "/home/bemeurer/.cache/zsh"
      "/home/bemeurer/.config/Element"
      "/home/bemeurer/.config/Signal"
      "/home/bemeurer/.config/TabNine"
      "/home/bemeurer/.config/dconf"
      "/home/bemeurer/.config/discord"
      "/home/bemeurer/.config/gcloud"
      "/home/bemeurer/.config/gopass"
      "/home/bemeurer/.config/pipewire"
      "/home/bemeurer/.config/shotwell"
      "/home/bemeurer/.gnupg"
      "/home/bemeurer/.local/share/TabNine"
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/direnv"
      "/home/bemeurer/.local/share/gopass"
      "/home/bemeurer/.local/share/iwctl"
      "/home/bemeurer/.local/share/keyrings"
      "/home/bemeurer/.local/share/lollypop"
      "/home/bemeurer/.local/share/nvim"
      "/home/bemeurer/.local/share/shotwell"
      "/home/bemeurer/.local/share/zsh"
      "/home/bemeurer/.aws"
      "/home/bemeurer/.mozilla"
      "/home/bemeurer/.ssh"
      "/home/bemeurer/.thunderbird"
      "/home/bemeurer/doc"
      "/home/bemeurer/img"
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

  home-manager.users.bemeurer.home.persistence."/nix/state/home/bemeurer" = {
    allowOther = true;
    files = [
      # ".cache/cargo/credentials"
      ".config/cachix/cachix.dhall"
      ".config/gh/hosts.yml"
      # ".gist-vim"
      ".local/share/wall.png"
    ];
  };
}
