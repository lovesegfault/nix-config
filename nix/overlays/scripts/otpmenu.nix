let
  otpmenu =
    { libnotify
    , jq
    , writeShellApplication

    , displayCmd
    , yankCmd
    , extraInputs ? [ ]
    }:
    writeShellApplication {
      name = "otpmenu";

      runtimeInputs = [
        jq
        libnotify
      ] ++ extraInputs;

      text = ''
        export PATH="/run/wrappers/bin:$PATH"
        eval "$(op signin)"
        items="$(op item list --categories=Login --format=json | jq -r '.[].title')"
        item="$(${displayCmd} <<< "$items")"
        otp_string="$(op item get --totp "$item")"
        ${yankCmd} <<< "$otp_string"
        notify-send "⏲ Copied $item to clipboard."
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

