{
  age.identityPaths = [ "/nix/state/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/nix/state" = {
    hideMounts = true;
    directories = [
      "/var/lib/iwd"
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
    users.bemeurer.directories = [
      ".cache/nix-index"
      ".cache/nvim"
      ".cache/zsh"
      ".local/share/atuin"
      ".local/share/bash"
      ".local/share/direnv"
      ".local/share/nvim"
      ".local/share/zsh"
      "src"
      "tmp"
      { directory = ".ssh"; mode = "0700"; }
    ];
  };
}
