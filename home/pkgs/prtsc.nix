{ pkgs, ... }:
let
  grim = "${pkgs.grim}/bin/grim";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  scrot = "${pkgs.scrot}/bin/scrot";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  xclip = "${pkgs.xclip}/bin/xclip";
in
{
  nixpkgs.overlays = [
    (
      self: super: {
        prtsc = super.writeScriptBin "prtsc" ''
          #!${super.stdenv.shell}
          set -o errexit
          set -o nounset
          set -o pipefail

          if [ "$(pgrep -x sway)" ]; then
              area="$(${slurp})"
              ${grim} -g "$area" - | ${wl-copy}
          elif [ "$(pgrep -x i3)" ]; then
              ${scrot} \
                  -s "/tmp/screenshot-$(date +%F_%T).png" \
                  -e "${xclip} -selection c -t image/png < \$f"
          else
              ${notify-send} "No tool set for WM"
          fi
        '';
      }
    )
  ];
}
