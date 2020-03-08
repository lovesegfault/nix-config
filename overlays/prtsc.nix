self: super:
let
  grim = "${super.grim}/bin/grim";
  notify-send = "${super.libnotify}/bin/notify-send";
  slurp = "${super.slurp}/bin/slurp";
  wl-copy = "${super.wl-clipboard}/bin/wl-copy";
in
{
  prtsc = super.writeScriptBin "prtsc" ''
    #!${super.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    if [ "$(pgrep -x sway)" ]; then
        area="$(${slurp})"
        ${grim} -t png -g "$area" - | ${wl-copy} -t image/png
    else
        ${notify-send} "No tool set for WM"
    fi
  '';
}
