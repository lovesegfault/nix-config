{ pkgs, ... }: {
  # This comes from https://github.com/lovesegfault/vim-config
  home.packages = with pkgs; [ neovim-lovesegfault ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.git.extraConfig.core.editor = "nvim";
}
