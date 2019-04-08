{ config, pkgs, ... }:

{
  programs.keychain = {
    enable = true;
  };
}
