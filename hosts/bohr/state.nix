{
  environment.persistence."/nix/state" = {
    directories = [
      "/etc/hqplayer"

      "/var/lib/docker"
      "/var/lib/hqplayer"
      "/var/lib/roon-server"
      "/var/lib/tailscale"
      "/var/log"

      "/home/bemeurer/.cache/nix-index"
      "/home/bemeurer/.cache/nvim"
      "/home/bemeurer/.cache/zsh"
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
}
