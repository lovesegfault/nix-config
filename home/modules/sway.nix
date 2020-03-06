{ config, lib, pkgs, ... }: {
  programs.zsh.profileExtra = ''
    # If running from tty1 start sway
    if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway > /tmp/sway.log 2>&1
    fi
  '';
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      bars = [
        {
          command = let
            waybar = (pkgs.waybar.override { pulseSupport = true; });
          in
            "${waybar}/bin/waybar";
          fonts = [ "FontAwesome 10" "Hack 10" ];
          workspaceNumbers = false;
        }
      ];
      colors = {
        focused = {
          border = "#30535F";
          background = "#30535F";
          text = "#F0BC8D";
          childBorder = "#A43C0F";
          indicator = "#A43C0F";
        };
        unfocused = {
          border = "#00122A";
          background = "#00122A";
          text = "#F0BC8D";
          childBorder = "#A43C0F";
          indicator = "#A43C0F";
        };
        urgent = {
          border = "#A43C0F";
          background = "#A43C0F";
          text = "#000000";
          childBorder = "#A43C0F";
          indicator = "#A43C0F";
        };
      };

      floating = {
        border = 0;
        modifier = modifier;
      };

      focus.followMouse = false;

      fonts = [ "FontAwesome 8" "Hack 8" ];

      gaps = {
        inner = 10;
        outer = 5;
        smartBorders = "on";
      };

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us";
          repeat_rate = "70";
        };

        "2131:308:LEOPOLD_Mini_Keyboard" = { xkb_layout = "us"; };

        "2:7:SynPS/2_Synaptics_TouchPad" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          dwt = "disabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "enabled";
        };

        "1739:0:Synaptics_TM3418-002" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          dwt = "disabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "enabled";
        };

        "2:8:AlpsPS/2_ALPS_DualPoint_TouchPad" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          dwt = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "enabled";
        };

        "2:10:TPPS/2_Elan_TrackPoint" = {
          accel_profile = "adaptive";
          dwt = "enabled";
        };

        "1133:16495:Logitech_MX_Ergo" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          natural_scroll = "enabled";
        };

        "1133:45085:MX_Ergo_Mouse" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          natural_scroll = "enabled";
        };
      };

      keybindings = let
        light = "${pkgs.light}/bin/light";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in
        lib.mkOptionDefault {
          # fancy workspace names
          "${modifier}+1" = "workspace 0:α";
          "${modifier}+2" = "workspace 1:β";
          "${modifier}+3" = "workspace 2:γ";
          "${modifier}+4" = "workspace 3:δ";
          "${modifier}+5" = "workspace 4:ε";
          "${modifier}+6" = "workspace 5:ζ";
          "${modifier}+7" = "workspace 6:η";
          "${modifier}+8" = "workspace 7:θ";
          "${modifier}+9" = "workspace 8:ι";
          "${modifier}+0" = "workspace 9:κ";
          "${modifier}+Shift+1" = "move container to workspace 0:α";
          "${modifier}+Shift+2" = "move container to workspace 1:β";
          "${modifier}+Shift+3" = "move container to workspace 2:γ";
          "${modifier}+Shift+4" = "move container to workspace 3:δ";
          "${modifier}+Shift+5" = "move container to workspace 4:ε";
          "${modifier}+Shift+6" = "move container to workspace 5:ζ";
          "${modifier}+Shift+7" = "move container to workspace 6:η";
          "${modifier}+Shift+8" = "move container to workspace 7:θ";
          "${modifier}+Shift+9" = "move container to workspace 8:ι";
          "${modifier}+Shift+0" = "move container to workspace 9:κ";
          # normal ones
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+m" = "exec ${pkgs.emojimenu}/bin/emojimenu";
          "${modifier}+o" = "exec ${pkgs.otpmenu}/bin/otpmenu";
          "${modifier}+p" = "exec ${pkgs.passmenu}/bin/passmenu";
          "${modifier}+q" = "exec ${pkgs.swaylock}/bin/swaylock -f";
          "Mod1+Tab" = " workspace next";
          "Mod4+Tab" = " workspace prev";
          "Mod4+comma" = " workspace prev";
          "Mod4+period" = " workspace next";
          "Print" = "exec ${pkgs.prtsc}/bin/prtsc";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPause" = "exec ${playerctl} pause";
          "XF86AudioPlay" = "exec ${playerctl} play";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "XF86MonBrightnessDown" = "exec ${light} -U 1";
          "XF86MonBrightnessUp" = "exec ${light} -A 1";
        };

      menu = "${terminal} -d 55 18 -t swaymenu -e ${pkgs.swaymenu}/bin/swaymenu";

      modifier = "Mod4";

      output = {
        "*" = { bg = "~/.wall fill"; };
        "Unknown 0x32EB 0x00000000" = {
          position = "0,0";
          resolution = "3840x2160";
          scale = "2";
          subpixel = "rgb";
        };
        "Dell Inc. DELL U2518D 0WG2J7C4A2AL" = {
          position = "1920,0";
          resolution = "3840x2160";
          scale = "2";
          subpixel = "rgb";
          transform = "90";
        };
      };

      startup = [
        {
          command = let
            swaylock = "${pkgs.swaylock}/bin/swaylock -f";
          in
            ''
              ${pkgs.swayidle}/bin/swayidle -w \
                timeout 300 '${swaylock}' \
                timeout 600 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep '${swaylock}'
            '';
        }
        { command = "${pkgs.xorg.xrdb}/bin/xrdb -load ~/.Xresources"; }
        { command = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY"; }
        { command = "pactl set-sink-mute @DEFAULT_SINK@ true"; }
        { command = "pactl set-source-mute @DEFAULT_SINK@ true"; }
        { command = "systemctl --user start gnome-keyring"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "${pkgs.redshift-wlr}/bin/redshift"; }
      ];

      terminal = "${pkgs.alacritty}/bin/alacritty";

      window = {
        border = 0;
        commands = let
          makeMenuWindow = "floating enable, border pixel 5, sticky enable";
        in
          [
            { command = makeMenuWindow; criteria = { app_id = "Alacritty"; title = "swaymenu"; }; }
            { command = makeMenuWindow; criteria = { app_id = "Alacritty"; title = "gopassmenu"; }; }
            { command = makeMenuWindow; criteria = { app_id = "Alacritty"; title = "emojimenu"; }; }
            { command = "floating enable"; criteria.app_id = "imv"; }
            { command = "floating enable, sticky enable"; criteria = { app_id = "firefox"; title = "Picture-in-Picture"; }; }
          ];
      };
    };

    extraSessionCommands = ''
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_WAYLAND_FORCE_DPI=physical
      export SDL_VIDEODRIVER=wayland
      export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1 sway
      export XDG_CURRENT_DESKTOP=Unity
      export _JAVA_AWT_WM_NONREPARENTING=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
    '';

    systemdIntegration = true;
    wrapperFeatures.gtk = true;
  };
}
