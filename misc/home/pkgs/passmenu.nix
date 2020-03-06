{ config, pkgs, ... }:
let
  gopass = "${pkgs.gopass}/bin/gopass";
  gopassmenu = import ./gopassmenu.nix { inherit pkgs; };
in
{
  nixpkgs.overlays = [
    (
      self: super: {
        passmenu = super.writeScriptBin "passmenu" ''
          #!${super.stdenv.shell}

          GOPASS_FILTER="^(misc|ssh|websites)/.*$"

          function gopass_get() {
            local name="$1"
            ${gopass} show --password "$name"
          }

          ${gopassmenu}
        '';
      }
    )
  ];
}
