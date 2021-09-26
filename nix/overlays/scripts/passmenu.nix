let
  passmenu =
    { gopass
    , libnotify
    , ripgrep
    , writeSaneShellScriptBin

    , displayCmd
    , yankCmd
    , pasteCmd
    , clearCmd
    , extraInputs ? [ ]
    }:
    writeSaneShellScriptBin {
      name = "passmenu";

      buildInputs = [
        gopass
        libnotify
        ripgrep
      ] ++ extraInputs;

      src = ''
        password_list="$(gopass ls -f | rg "^(misc|hosts|websites)/.*$")"
        password_name="$(${displayCmd} <<< "$password_list")"
        password="$(gopass show --password "$password_name")"

        ${yankCmd} <<< "$password"
        notify-send "🔏 Copied $password_name to clipboard. Will clear in 45 seconds."

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
self: _: {
  passmenu-wayland = self.callPackage passmenu {
    displayCmd = ''wofi --cache-file="$XDG_CACHE_HOME/wofi/passmenu" -p pass --show dmenu'';
    yankCmd = "wl-copy --trim-newline";
    pasteCmd = "wl-paste";
    clearCmd = "wl-copy --clear";
    extraInputs = with self; [ wl-clipboard wofi ];
  };

  passmenu-x11 = self.callPackage passmenu {
    displayCmd = ''rofi -cache-dir "$XDG_CACHE_HOME/rofi/passmenu" -p pass -dmenu'';
    yankCmd = "xclip -in -rmlastnl -selection clipboard";
    pasteCmd = "xclip -out -selection clipboard 2>&1";
    clearCmd = ''xclip -in -selection clipboard <<< ""'';
    extraInputs = with self; [ rofi xclip ];
  };
}
