{ pkgs, ... }: {
  programs.zsh = {
    plugins = [{
      # https://github.com/romkatv/powerlevel10k/releases
      name = "powerlevel10k";
      file = "powerlevel10k.zsh-theme";
      src = pkgs.fetchFromGitHub {
        owner = "romkatv";
        repo = "powerlevel10k";
        rev = "v1.13.0";
        sha256 = "0w5rv7z47nys3x113mdddpb2pf1d9pmz9myh4xjzrcy4hp4qv421";
      };
    }];
    initExtra = ''
      source ${./powerlevel10k.zsh}
      typeset -g POWERLEVEL9K_CONFIG_FILE=${builtins.toString ./powerlevel10k.zsh}
    '';
  };
}
