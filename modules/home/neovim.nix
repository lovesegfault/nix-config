{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
{
  # This comes from https://github.com/lovesegfault/vim-config
  # c.f. https://github.com/danth/stylix/blob/e7c09d206680e6fe6771e1ac9a83515313feaf95/docs/src/configuration.md#standalone-nixvim
  # mkOrder 100: Very early to come right after stylix, before all programs.*
  home.packages = lib.mkOrder 100 [
    (flake.inputs.lovesegfault-vim-config.packages.${pkgs.stdenv.hostPlatform.system}.neovim.extend
      config.stylix.targets.nixvim.exportedModule
    )
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git.settings.core.editor = "nvim";
}
