{ config, pkgs, ... }:
{
  # This comes from https://github.com/lovesegfault/vim-config
  # c.f. https://github.com/danth/stylix/blob/e7c09d206680e6fe6771e1ac9a83515313feaf95/docs/src/configuration.md#standalone-nixvim
  home.packages = [ (pkgs.neovim-lovesegfault.extend config.lib.stylix.nixvim.config) ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.git.extraConfig.core.editor = "nvim";
}
