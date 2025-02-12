{
  ezModules,
  lib,
  inputs,
  ...
}:
{
  imports = lib.attrValues {
    inherit (ezModules)
      core
      dev
      uid
      ;
  };

  programs.home-manager.enable = true;
}
