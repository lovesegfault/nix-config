{ config, pkgs, ... }:

{
  programs.neovim = if config.isArm then {
    enable = false;
  } else {
    enable = true;
    configure = {};
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;
  };
}
