let
  drunmenu =
    { spawn
    , writeShellApplication

    , displayCmd
    , extraInputs ? [ ]
    }:
    writeShellApplication {
      name = "drunmenu";

      runtimeInputs = [ spawn ] ++ extraInputs;

      text = ''
        program="$(${displayCmd})"

        exec spawn "$program"
      '';
    };
in
self: _: {
  drunmenu-wayland = self.callPackage drunmenu {
    displayCmd = ''
      wofi \
        --allow-images \
        --allow-markup \
        --insensitive \
        --define "drun-print_command=true" \
        --term=foot \
        --cache-file="$XDG_CACHE_HOME/wofi/drunmenu" \
        --show=drun |
        sed "s/%[a-zA-Z]//g"
    '';
    extraInputs = with self; [ gnused wofi ];
  };

  drunmenu-x11 = self.callPackage drunmenu {
    displayCmd = ''
      rofi \
        -cache-dir "$XDG_CACHE_HOME/rofi/drunmenu" \
        -run-command "echo {cmd}" \
        -show drun
    '';
    extraInputs = with self; [ rofi ];
  };
}
