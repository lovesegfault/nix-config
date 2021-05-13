self: _: {
  otpmenu = self.callPackage
    (
      { gopass
      , libnotify
      , ripgrep
      , wl-clipboard
      , wofi
      , writeSaneShellScriptBin
      }:
      writeSaneShellScriptBin {
        name = "otpmenu";

        buildInputs = [
          gopass
          libnotify
          ripgrep
          wl-clipboard
          wofi
        ];

        src = ''
          if [ -z ''${XDG_CACHE_HOME+x} ]; then
            cache_file="$HOME/.cache/otpmenu"
          else
            cache_file="$XDG_CACHE_HOME/otpmenu"
          fi

          otp_list="$(gopass ls -f | rg "^(otp)/.*$")"
          otp_name="$(wofi \
            --show dmenu \
            --cache-file="$cache_file" \
            <<< "$otp_list" \
          )"
          otp_string="$(gopass otp "$otp_name")"

          otp_code="$(cut -f1 -d " " <<< "$otp_string")"
          otp_duration="$(cut -f 3 -d " " <<< "$otp_string")"

          wl-copy --trim-newline <<< "$otp_code"
          notify-send "⏲ Copied $otp_name to clipboard. Lasts $otp_duration."
        '';
      }
    )
    { };
}

