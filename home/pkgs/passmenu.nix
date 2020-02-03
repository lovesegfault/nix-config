{ config, pkgs, ... }:
let
  gopassmenu = import ./gopassmenu.nix { inherit pkgs; };
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
in {
  nixpkgs.overlays = [
    (self: super: {
      passmenu = super.writeScriptBin "passmenu" ''
        #!${super.stdenv.shell}

        GOPASS_FILTER="^(misc|ssh|websites)/.*$"

        function gopass_paste() {
          local password="$1"
          ${wl-copy} -o "$password"
        }

        ${gopassmenu}
      '';
    })
  ];
}
