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
      ".config/dconf"
      ".config/discord"
      ".config/gcloud"
      ".config/gopass"
      ".config/shotwell"
      ".gnupg/private-keys-v1.d"
      ".gsutil"
      ".local/share/keyrings"
      ".local/share/lollypop"
      ".local/share/nix"
      ".local/share/nvim"
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
      ".arcrc"
      ".cache/swaymenu-history.txt"
      ".config/zoomus.conf"
      ".gist"
      ".gist-vim"
      ".gnupg/pubring.kbx"
      ".gnupg/random_seed"
      ".gnupg/sshcontrol"
      ".gnupg/trustdb.gpg"
      ".local/share/bash_history"
      ".local/share/zsh_history"
      ".newsboat/cache.db"
      ".newsboat/history.search"
      ".wall"
    ];
  };
}
