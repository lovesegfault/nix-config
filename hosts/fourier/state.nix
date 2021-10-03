{
  environment.persistence."/nix/state" = {
    directories = [
      "/etc/dnsmasq.d"

      "/var/lib/chrony"
      "/var/lib/containers"
      "/var/lib/grafana"
      "/var/lib/iwd"
      "/var/lib/pihole"
      "/var/lib/plex"
      "/var/lib/prometheus2"
      "/var/lib/tailscale"
      "/var/lib/unbound"
      "/var/log"

      "/home/bemeurer/.cache/nix-index"
      "/home/bemeurer/.cache/nvim"
      "/home/bemeurer/.cache/zsh"
      "/home/bemeurer/.config/beets"
      "/home/bemeurer/.config/coc"
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/direnv"
      "/home/bemeurer/.local/share/nvim"
      "/home/bemeurer/.local/share/zsh"
      "/home/bemeurer/.ssh"
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
      ".gist-vim"
    ];
  };
}
