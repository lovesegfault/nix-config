self: _: {
  swaymenu = self.callPackage
    (
      { spawn
      , wofi
      , writeSaneShellScriptBin
      }:
      writeSaneShellScriptBin {
        name = "swaymenu";

        buildInputs = [
          spawn
          wofi
        ];

        src = ''
          if [ -z ''${XDG_CACHE_HOME+x} ]; then
            cache_file="$HOME/.cache/wofi/swaymenu"
          else
            cache_file="$XDG_CACHE_HOME/wofi/swaymenu"
          fi

          program="$(wofi \
            --allow-images \
            --allow-markup \
            --insensitive \
            --define "drun-print_command=true" \
            --term=foot \
            --cache-file="$cache_file" \
            --show=drun
          )"

          spawn "$program"
        '';
      }
    )
    { };
}


