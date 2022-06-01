let
  passmenu =
    { libnotify
    , jq
    , writeShellApplication

    , displayCmd
    , yankCmd
    , pasteCmd
    , clearCmd
    , extraInputs ? [ ]
    }:
    writeShellApplication {
      name = "passmenu";

      runtimeInputs = [
        jq
        libnotify
      ] ++ extraInputs;

      text = ''
        export PATH="/run/wrappers/bin:$PATH"
        eval "$(op signin)"
        items="$(op item list --categories=Login --format=json | jq -r '.[].title')"
        item="$(${displayCmd} <<< "$items")"
        password="$(op item get --fields label=password "$item")"
        ${yankCmd} <<< "$password"
        notify-send "🔏 Copied $item to clipboard. Will clear in 45 seconds."

        # wait 45 seconds, or until the clipboard changes.
        counter=0
        while [ "$counter" -lt 45 ]; do
          counter=$((counter + 1))
          if [ "$password" != "$(${pasteCmd})" ]; then
            exit 0
          fi
          sleep 1
        done

        ${clearCmd}
        notify-send "🧹 Clipboard cleared."
      '';
    };
in
final: _: {
  passmenu-wayland = final.callPackage passmenu {
    displayCmd = ''wofi --cache-file="$XDG_CACHE_HOME/wofi/passmenu" -p pass --show dmenu'';
    yankCmd = "wl-copy --trim-newline";
    pasteCmd = "wl-paste";
    clearCmd = "wl-copy --clear";
    extraInputs = with final; [ wl-clipboard wofi ];
  };

  passmenu-x11 = final.callPackage passmenu {
    displayCmd = ''rofi -cache-dir "$XDG_CACHE_HOME/rofi/passmenu" -p pass -dmenu'';
    yankCmd = "xclip -in -rmlastnl -selection clipboard";
    pasteCmd = "xclip -out -selection clipboard 2>&1";
    clearCmd = ''xclip -in -selection clipboard <<< ""'';
    extraInputs = with final; [ rofi xclip ];
  };
}
