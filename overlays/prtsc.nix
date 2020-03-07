self: super: let
  grim = "${super.grim}/bin/grim";
  notify-send = "${super.libnotify}/bin/notify-send";
  scrot = "${super.scrot}/bin/scrot";
  slurp = "${super.slurp}/bin/slurp";
  wl-copy = "${super.wl-clipboard}/bin/wl-copy";
  xclip = "${super.xclip}/bin/xclip";
in {
  prtsc = super.writeScriptBin "prtsc" ''
    #!${super.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail

    if [ "$(pgrep -x sway)" ]; then
        area="$(${slurp})"
        ${grim} -t png -g "$area" - | ${wl-copy} -t image/png
    elif [ "$(pgrep -x i3)" ]; then
        ${scrot} \
            -s "/tmp/screenshot-$(date +%F_%T).png" \
            -e "${xclip} -selection c -t image/png < \$f"
    else
        ${notify-send} "No tool set for WM"
    fi
  '';
}
