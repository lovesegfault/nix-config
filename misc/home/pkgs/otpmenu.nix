{ config, pkgs, ... }:
let
  gopassmenu = import ./gopassmenu.nix { inherit pkgs; };
  gopass = "${pkgs.gopass}/bin/gopass";
in
{
  nixpkgs.overlays = [
    (
      self: super: {
        otpmenu = super.writeScriptBin "otpmenu" ''
          #!${super.stdenv.shell}

          GOPASS_FILTER="^(otp)/.*$"

          function gopass_get() {
            local name="$1"
            ${gopass} otp $name | cut -f 1 -d ' '
          }

          ${gopassmenu}
        '';
      }
    )
  ];
}
