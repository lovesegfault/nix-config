{ config, pkgs, ... }:
let
  menu = import ./execmenu.nix { inherit pkgs; };
in
{
  nixpkgs.overlays = [
    (
      self: super: {
        i3menu = super.writeScriptBin "i3menu" ''
          #!${super.stdenv.shell}
          ${menu}
          (exec i3-msg -t command "exec $COMMAND")
        '';
      }
    )
  ];
}
