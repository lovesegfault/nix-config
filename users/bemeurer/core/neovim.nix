{ pkgs, ... }: {
  # This comes from https://github.com/lovesegfault/vim-config
  home.packages = with pkgs; [ neovim-lovesegfault ];
  programs.git.extraConfig.core.editor = "nvim";
}
