{
  environment.persistence."/nix/state" = {
    directories = [
      "/var/lib/docker"
      "/var/lib/grafana"
      "/var/lib/iwd"
      "/var/lib/plex"
      "/var/lib/prometheus2"
      "/var/lib/roon-server"
      "/var/lib/tailscale"
      "/var/log"

      "/home/bemeurer/.cache/zsh"
      "/home/bemeurer/.local/share/bash"
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
      ".newsboat/cache.db"
      ".newsboat/history.search"
    ];
  };
}
