{ config, pkgs, ... }:
let menu = import ./menu.nix { inherit pkgs; };
in {
  nixpkgs.overlays = [
    (self: super: {
      swaymenu = super.writeScriptBin "swaymenu" ''
        #!${super.stdenv.shell}
        ${menu}
        (exec swaymsg -t command "exec $COMMAND")
      '';
    })
  ];
}
