{ pkgs, ... }: {
  home = {
    sessionVariables = rec {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = EDITOR;
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };
    stateVersion = "20.03";
  };
}
