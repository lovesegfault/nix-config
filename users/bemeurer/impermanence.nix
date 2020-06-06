{ ... }: {
  imports = [ (import ../../nix).home-impermanence ];

  home.persistence."/state/home/bemeurer" = {
    directories = [
      ".cache/lollypop"
      ".cache/mozilla"
      ".cache/nix"
      ".cache/nvim"
      ".cache/shotwell"
      ".cache/thunderbird"
      ".cache/zoom"
      ".config/Slack"
      ".config/discord"
      ".config/gcloud"
      ".config/gopass"
      ".config/shotwell"
      ".gnupg/private-keys-v1.d"
      ".gsutil"
      ".local/share/keyrings"
      ".local/share/lollypop"
      ".local/share/nix"
      ".local/share/shotwell"
      ".mozilla"
      ".password-store"
      ".ssh"
      ".thunderbird"
      ".zoom"
      "documents"
      "opt"
      "src"
      "tmp"
    ];
    files = [
      ".cache/swaymenu-history.txt"
      ".config/zoomus.conf"
      ".gist"
      ".gist-vim"
      ".local/share/bash_history"
      ".local/share/zsh_history"
      ".wall"
      ".newsboat/cache.db"
      ".newsboat/history.search"
      ".gnupg/pubring.kbx"
      ".gnupg/trustdb.gpg"
      ".gnupg/sshcontrol"
      ".gnupg/random_seed"
    ];
  };
}
