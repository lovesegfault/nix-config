{ config, lib, pkgs, ... }: {
  imports = [ ../pkgs/gebaar.nix ../pkgs/passmenu.nix ../pkgs/prtsc.nix ../pkgs/swaymenu.nix ];

  xdg.configFile.gebaar = {
    target = "gebaar/gebaard.toml";
    text = ''
      [commands.swipe.three]
      left_up = ""
      right_up = ""
      up = ""
      left_down = ""
      right_down = ""
      down = ""
      left = "swaymsg \"workspace next\""
      right = "swaymsg \"workspace prev\""
    '';
  };

  xsession = rec {
    windowManager.i3 = {
      enable = true;
      config = rec {
        floating = {
          border = 0;
          criteria = [ { title = "swaymenu"; } { title = "passmenu"; } ];
          modifier = modifier;
        };

        focus = {
          followMouse = false;
          mouseWarping = false;
          newWindow = "smart";
        };

        fonts = [ "Hack 8" ];

        gaps = {
          inner = 5;
          outer = 10;
          smartBorders = "on";
          smartGaps = false;
        };

        keybindings = let
          dunst = "${pkgs.dunst}/bin/dunst";
          feh = "${pkgs.feh}/bin/feh";
          gebaard = "${pkgs.gebaar}/bin/gebaard";
          light = "${pkgs.light}/bin/light";
          lock = "i3lock -i ~/pictures/walls/clouds.png -e -f";
          menu = "${term} -d 80 20 -t swaymenu -e ${swaymenu}";
          passmenu = "${pkgs.passmenu}/bin/passmenu";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          prtsc = "${pkgs.prtsc}/bin/prtsc";
          redshift = "${pkgs.redshift}/bin/redshift";
          swaymenu = "${pkgs.swaymenu}/bin/swaymenu";
          term = "${pkgs.alacritty}/bin/alacritty";
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${term}";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+p" = "exec ${passmenu}";
          "Print" = "exec ${prtsc}";
          "XF86MonBrightnessUp" = "exec ${light} -A 1";
          "XF86MonBrightnessDown" = "exec ${light} -U 1";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86Display" = "exec ${lock}";
          "XF86AudioPlay" = "exec ${playerctl} play";
          "XF86AudioPause" = "exec ${playerctl} pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+1" = "workspace 1:α";
          "${modifier}+2" = "workspace 2:β";
          "${modifier}+3" = "workspace 3:γ";
          "${modifier}+4" = "workspace 4:δ";
          "${modifier}+5" = "workspace 5:ε";
          "${modifier}+6" = "workspace 6:ζ";
          "${modifier}+7" = "workspace 7:η";
          "${modifier}+8" = "workspace 8:θ";
          "${modifier}+9" = "workspace 9:ι";
          "${modifier}+0" = "workspace 10:κ";
          "${modifier}+Shift+1" = "move container to workspace 1:α";
          "${modifier}+Shift+2" = "move container to workspace 2:β";
          "${modifier}+Shift+3" = "move container to workspace 3:γ";
          "${modifier}+Shift+4" = "move container to workspace 4:δ";
          "${modifier}+Shift+5" = "move container to workspace 5:ε";
          "${modifier}+Shift+6" = "move container to workspace 6:ζ";
          "${modifier}+Shift+7" = "move container to workspace 7:η";
          "${modifier}+Shift+8" = "move container to workspace 8:θ";
          "${modifier}+Shift+9" = "move container to workspace 9:ι";
          "${modifier}+Shift+0" = "move container to workspace 10:κ";
          "Mod1+Tab" = "workspace next";
          "Mod4+Tab" = "workspace prev";
          "${modifier}+period" = "workspace next";
          "${modifier}+comma" = "workspace prev";
        };

        modifier = "Mod4";

        startup = [
          { command = "dbus-update-activation-environment --systemd DISPLAY"; }
          { command = "${dunst}"; }
          { command = "${feh} --bg-fill ~/pictures/walls/clouds.png"; }
          { command = "${gebaard}"; }
          { command = "pactl set-sink-mute @DEFAULT_SINK@ true"; }
          { command = "pactl set-source-mute @DEFAULT_SOURCE@ true"; }
          { command = "${redshift}"; }
          { command = "systemctl --user start gnome-keyring"; }
        ];

        window.border = 0;
      };
    };
  };
}
