{ config, ... }: {
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

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
      {
        directory = "/var/lib/syncthing";
        inherit (config.services.syncthing) user group;
      }
      "/var/lib/tailscale"
      "/var/lib/unbound"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
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
      ".config/coc"
      ".local/share/atuin"
      ".local/share/bash"
      ".local/share/direnv"
      ".local/share/nvim"
      ".local/share/zsh"
      "src"
      "tmp"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
    ];
  };
}
