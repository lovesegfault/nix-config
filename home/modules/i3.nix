{ config, lib, pkgs, ... }: {
  imports = [ ../pkgs/passmenu.nix ../pkgs/prtsc.nix ../pkgs/swaymenu.nix ];

  xdg.configFile.libinput-gestures = {
    target = "libinput-gestures.conf";
    text = let i3-msg = "${pkgs.i3-gaps}/bin/i3-msg";
    in ''
      gesture swipe left 3 ${i3-msg} "workspace next"
      gesture swipe right 3 ${i3-msg} "workspace prev"
    '';
  };

  xsession = rec {
    windowManager.command = "${windowManager.i3.package}/bin/i3";
    windowManager.i3 = rec {
      enable = true;
      config = {
        bars = let
          bar = "${pkgs.i3status-rust}/bin/i3status-rs";
          cfg = config.xdg.configHome
            + "/${config.xdg.configFile.i3status-rust.target}";
        in [{
          statusCommand = "${bar} ${cfg}";
          fonts = [ "FontAwesome 10" "Hack 10" ];
          position = "top";
          workspaceNumbers = false;
          colors.background = "#424242";
        }];

        floating = {
          border = 0;
          criteria = [ { title = "menu"; } { title = "passmenu"; } ];
          modifier = modifier;
        };

        focus = {
          followMouse = false;
          mouseWarping = false;
          newWindow = "smart";
        };

        fonts = [ "FontAwesome 8" "Hack 8" ];

        gaps = {
          inner = 5;
          outer = 10;
          smartBorders = "on";
          smartGaps = "false";
        };

        keybindings = let
          light = "${pkgs.light}/bin/light";
          lock = "${pkgs.i3lock} -i ~/pictures/walls/clouds.png -e -f";
          pactl = "${pkgs.pulseaudioFull}/bin/pactl";
          passmenu = "${pkgs.passmenu}/bin/passmenu";
          prtsc = "${pkgs.prtsc}/bin/prtsc";
          swaymenu =
            "${term} -d 80 20 -t swaymenu -e ${pkgs.swaymenu}/bin/swaymenu";
          term = "${pkgs.alacritty}/bin/alacritty";
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${term}";
          "${modifier}+d" = "exec ${swaymenu}";
          "${modifier}+p" = "exec ${passmenu}";
          "Print" = "exec ${prtsc}";
          "XF86MonBrightnessUp" = "exec ${light} -A 1";
          "XF86MonBrightnessDown" = "exec ${light} -U 1";
          "XF86AudioRaiseVolume" =
            "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +1%";
          "XF86AudioLowerVolume" =
            "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" =
            "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86Display" = "exec ${lock}";
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

        startup = let
          dunst = "${pkgs.dunst}/bin/dunst";
          feh = "${pkgs.feh}/bin/feh";
          pactl = "${pkgs.pulseaudioFull}/bin/pactl";
          libinput-gestures = "${pkgs.libinput-gestures}/bin/libinput-gestures";
        in [
          { command = "${feh} --bg-fill ~/pictures/walls/clouds.png"; }
          { command = "${pactl} set-sink-mute @DEFAULT_SINK@ true"; }
          { command = "${pactl} set-source-mute @DEFAULT_SOURCE@ true"; }
          { command = "dbus-update-activation-environment --all"; }
          { command = "systemctl --user start gnome-keyring"; }
          { command = dunst; }
          { command = libinput-gestures; }
        ];

        window.border = 0;
      };
    };
  };
}
