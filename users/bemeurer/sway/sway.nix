{ lib, pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      bars = [ ];

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

      fonts = [ "FontAwesome 10" "Iosevka 10" ];

      gaps = lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") {
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

      keybindings = lib.mkOptionDefault {
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
        "Print" = "exec ${pkgs.grim}/bin/grim -t png -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
        "XF86AudioLowerVolume" = "exec ${pkgs.ponymix}/bin/ponymix decrease 1";
        "XF86AudioMicMute" = "exec ${pkgs.ponymix}/bin/ponymix -t source toggle";
        "XF86AudioMute" = "exec ${pkgs.ponymix}/bin/ponymix -t sink toggle";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioRaiseVolume" = "exec ${pkgs.ponymix}/bin/ponymix increase 1";
        "XF86MonBrightnessDown" = "exec ${pkgs.brillo}/bin/brillo -e -U 0.5";
        "XF86MonBrightnessUp" = "exec ${pkgs.brillo}/bin/brillo -e -A 0.5";
      };

      menu = "${terminal} -t swaymenu -e ${pkgs.swaymenu}/bin/swaymenu";

      modifier = if pkgs.hostPlatform.system == "aarch64-linux" then "Mod1" else "Mod4";

      output = {
        "*" = { bg = "~/.wall fill"; };
        "Unknown 0x32EB 0x00000000" = {
          mode = "3840x2160@60Hz";
          position = "960,2880";
          scale = "2";
          subpixel = "rgb";
        };
        "Goldstar Company Ltd LG Ultra HD 0x00000B08" = {
          adaptive_sync = "on";
          mode = "3840x2160@60Hz";
          position = "0,720";
          subpixel = "rgb";
        };
        "Goldstar Company Ltd LG Ultra HD 0x00009791" = {
          adaptive_sync = "on";
          mode = "3840x2160@60Hz";
          position = "3840,0";
          subpixel = "rgb";
          transform = "270";
        };
        "DSI-1" = {
          mode = "480x800@60Hz";
          position = "0,0";
          subpixel = "rgb";
          transform = "90";
        };
      };

      terminal = if pkgs.hostPlatform.system == "aarch64-linux" then
                  "${pkgs.termite}/bin/termite"
                else
                  "${pkgs.alacritty}/bin/alacritty";

      window = {
        border = 0;
        commands =
          let
            makeMenuWindow = "floating enable, border pixel 5, sticky enable";
          in
          [
            { command = makeMenuWindow; criteria.title = "emojimenu"; }
            { command = makeMenuWindow; criteria.title = "otpmenu"; }
            { command = makeMenuWindow; criteria.title = "passmenu"; }
            { command = makeMenuWindow; criteria.title = "swaymenu"; }
            { command = "floating enable"; criteria.app_id = "imv"; }
            { command = "floating enable, sticky enable"; criteria = { app_id = "firefox"; title = "Picture-in-Picture"; }; }
          ];
      };
    };

    extraConfig = ''
      bindswitch --locked --reload lid:on output eDP-1 disable
      bindswitch --locked --reload lid:off output eDP-1 enable
      focus output eDP-1
      workspace 0:α
    '';

    extraSessionCommands = ''
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_WAYLAND_FORCE_DPI=physical
      export SDL_VIDEODRIVER=wayland
      export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1 sway
      export _JAVA_AWT_WM_NONREPARENTING=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
    '';

    systemdIntegration = true;
    wrapperFeatures.gtk = true;
  };
}
