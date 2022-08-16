{
  programs.sway.enable = true;

  home-manager.users.bemeurer = {
    home.sessionVariables = {
      GDK_DPI_SCALE = "1.2";
      ELM_SCALE = "1.2";
    };

    wayland.windowManager.sway = {
      config = {
        input = {
          "1267:12849:ELAN06A0:00_04F3:3231_Touchpad" = {
            accel_profile = "adaptive";
            click_method = "button_areas";
            dwt = "disabled";
            natural_scroll = "enabled";
            scroll_method = "two_finger";
            tap = "enabled";
          };

          "2:10:TPPS/2_Elan_TrackPoint" = {
            accel_profile = "adaptive";
            dwt = "enabled";
          };
        };
        output = {
          "Unknown 0x4167 0x00000000" = {
            mode = "2880x1800@60Hz";
            position = "0,0";
            scale = "1";
            subpixel = "rgb";
          };
        };
      };
      extraConfig = ''
        bindswitch --locked --reload lid:on output eDP-1 disable
        bindswitch --locked --reload lid:off output eDP-1 enable
      '';
    };

    programs.mako.font = "monospace 18";

    programs.waybar.style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: monospace;
        font-size: 18px;
        min-height: 0;
      }

      #waybar {
        background-color: #0D1016;
        color: #B3B1AD;
        transition: background-color 0.2s;
      }

      #waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        margin: 0 3px 0 1px;
      }

      #workspaces button {
        background: transparent;
        border: none;
        padding: 0 8px;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        border-bottom: 3px solid #E6B450;
      }

      #workspaces button.focused {
        background-color: #273747;
        color: #E6B450;
        border-bottom: 3px solid #E6B450;
      }

      #workspaces button.urgent {
        color: #FF3333;
      }

      #battery,
      #clock,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #idle_inhibitor,
      #mode {
        padding: 0 5px;
        margin: 0 2px;
      }

      #idle_inhibitor.activated {
        color: #E6B450;
        background-color: #273747;
      }
    '';
  };
}
