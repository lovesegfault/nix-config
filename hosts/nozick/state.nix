{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    directories = [
      "/var/lib/acme"
      "/var/lib/chrony"
      "/var/lib/containers"
      "/var/lib/deluge"
      "/var/lib/grafana"
      "/var/lib/nextcloud"
      "/var/lib/plex"
      "/var/lib/postgresql"
      "/var/lib/private/ddclient"
      "/var/lib/prometheus2"
      "/var/lib/sshguard"
      "/var/lib/tailscale"
      "/var/lib/unbound"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nginx/certs/origin-pull-ca.pem"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.bemeurer.directories = [
      ".cache/nix-index"
      ".cache/nvim"
      ".cache/zsh"
      ".config/beets"
      ".config/rclone"
      ".local/share/atuin"
      ".local/share/bash"
      ".local/share/direnv"
      ".local/share/nvim"
      ".local/share/zsh"
      "src"
      "tmp"
      "opt"
      "doc"
    ];
  };
}
