let
  otpmenu =
    { gopass
    , libnotify
    , ripgrep
    , writeShellApplication

    , displayCmd
    , yankCmd
    , extraInputs ? [ ]
    }:
    writeShellApplication {
      name = "otpmenu";

      runtimeInputs = [
        gopass
        libnotify
        ripgrep
      ] ++ extraInputs;

      text = ''
        otp_list="$(gopass ls -f | rg "^(otp)/.*$")"
        otp_name="$(${displayCmd} <<< "$otp_list")"
        otp_string="$(gopass otp "$otp_name")"

        otp_code="$(cut -f1 -d " " <<< "$otp_string")"
        otp_duration="$(cut -f 3 -d " " <<< "$otp_string")"

        ${yankCmd} <<< "$otp_code"
        notify-send "⏲ Copied $otp_name to clipboard. Lasts $otp_duration."
      '';
    };
in
final: _: {
  otpmenu-wayland = final.callPackage otpmenu {
    displayCmd = ''wofi --cache-file="$XDG_CACHE_HOME/wofi/otpmenu" -p otp --show dmenu'';
    yankCmd = "wl-copy --trim-newline";
    extraInputs = with final; [ wl-clipboard wofi ];
  };

  otpmenu-x11 = final.callPackage otpmenu {
    displayCmd = ''rofi -cache-dir "$XDG_CACHE_HOME/rofi/otpmenu" -p otp -dmenu'';
    yankCmd = "xclip -in -rmlastnl -selection clipboard";
    extraInputs = with final; [ rofi xclip ];
  };
}

