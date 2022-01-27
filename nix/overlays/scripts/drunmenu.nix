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

        # shellcheck disable=SC2086
        exec spawn $program
      '';
    };
in
final: _: {
  drunmenu-wayland = final.callPackage drunmenu {
    displayCmd = ''
      wofi \
        --allow-images \
        --allow-markup \
        --insensitive \
        --define "drun-print_command=true" \
        --term=foot \
        --cache-file="''${XDG_CACHE_HOME:-$HOME/.cache}/wofi/drunmenu" \
        --show=drun |
        sed "s/%[a-zA-Z]//g"
    '';
    extraInputs = with final; [ gnused wofi ];
  };

  drunmenu-x11 = final.callPackage drunmenu {
    displayCmd = ''
      rofi \
        -cache-dir "''${XDG_CACHE_HOME:-$HOME/.cache}/rofi/drunmenu" \
        -run-command "echo {cmd}" \
        -show drun
    '';
    extraInputs = with final; [ rofi ];
  };
}
