self: _: {
  passmenu = self.callPackage
    (
      { gopass
      , libnotify
      , ripgrep
      , wl-clipboard
      , wofi
      , writeSaneShellScriptBin
      }:
      writeSaneShellScriptBin {
        name = "passmenu";

        buildInputs = [
          gopass
          libnotify
          ripgrep
          wl-clipboard
          wofi
        ];

        src = ''
          if [ -z ''${XDG_CACHE_HOME+x} ]; then
            cache_file="$HOME/.cache/wofi/passmenu"
          else
            cache_file="$XDG_CACHE_HOME/wofi/passmenu"
          fi

          password_list="$(gopass ls -f | rg "^(misc|hosts|websites)/.*$")"
          password_name="$(wofi \
            --show dmenu \
            --cache-file="$cache_file" \
            <<< "$password_list" \
          )"
          password="$(gopass show --password "$password_name")"

          wl-copy --trim-newline <<< "$password"
          notify-send "🔏 Copied $password_name to clipboard. Will clear in 45 seconds."

          sleep 45

          wl-copy --clear
          notify-send "🧹 Clipboard cleared."
        '';
      }
    )
    { };
}


