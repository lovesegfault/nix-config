{
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
      "/home/bemeurer/.config/Signal"
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

  home-manager.users.bemeurer.home.persistence."/state/home/bemeurer" = {
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
}
