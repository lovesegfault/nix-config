{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    hideMounts = true;
    directories = [
      {
        directory = "/var/lib/chrony";
        user = "chrony";
        group = "chrony";
      }
      "/var/lib/containers"
      "/var/lib/fwupd"
      "/var/lib/libvirt"
      "/var/lib/nixos"
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
        ".cache/.direnv"
        ".cache/nix"
        ".cache/nvim"
        ".cache/zsh"
        ".local/share/atuin"
        ".local/share/bash"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/nvim"
        ".local/share/zsh"
        "doc"
        "opt"
        "src"
        "tmp"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
      files = [
        ".config/cachix/cachix.dhall"
        ".config/gh/hosts.yml"
      ];
    };
  };
}
