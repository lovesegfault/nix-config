{ config, ... }: {
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    directories = [
      { directory = "/var/lib/chrony"; user = "chrony"; group = "chrony"; }
      "/var/lib/fwupd"
      { directory = "/var/lib/hqplayer"; user = "hqplayer"; group = "hqplayer"; }
      "/var/lib/iwd"
      { directory = "/var/lib/roon-server"; inherit (config.services.roon-server) user group; }
      { directory = "/var/lib/syncthing"; inherit (config.services.syncthing) user group; }
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
        ".cache/.direnv"
        ".cache/nix"
        ".cache/nix-index"
        ".cache/nvim"
        ".cache/zsh"
        ".config/TabNine"
        ".config/beets"
        ".local/share/atuin"
        ".local/share/bash"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/iwctl"
        ".local/share/nvim"
        ".local/share/zsh"
        "doc"
        "opt"
        "src"
        "tmp"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
      files = [
        ".config/cachix/cachix.dhall"
        ".config/gh/hosts.yml"
      ];
    };
  };
}
