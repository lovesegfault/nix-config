{
  wayland.windowManager.sway = {
    config = {
      input = {
        "1739:52619:SYNA8006:00_06CB:CD8B_Touchpad" = {
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

        "2:10:TPPS/2_Elan_TrackPoint" = {
          accel_profile = "adaptive";
          dwt = "enabled";
        };

        "1133:16495:Logitech_MX_Ergo" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          natural_scroll = "enabled";
        };

        "1133:45085:Logitech_MX_Ergo_Multi-Device_Trackball" = {
          accel_profile = "adaptive";
          click_method = "button_areas";
          natural_scroll = "enabled";
        };
      };
      output = {
        "Samsung Electric Company LF32TU87 HCPRA06514" = {
          mode = "3840x2160@60Hz";
          subpixel = "rgb";
        };
        "Unknown 0x1400 0x00000000" = {
          mode = "3840x2160@60Hz";
          scale = "2";
          subpixel = "rgb";
        };
      };
    };
    extraConfig = ''
      bindswitch --locked --reload lid:on output eDP-1 disable
      bindswitch --locked --reload lid:off output eDP-1 enable
      workspace 1 output "Unknown 0x32EB 0x00000000"
      focus output "Unknown 0x1400 0x00000000"
    '';
  };

  services.kanshi = {
    enable = true;
    profiles = {
      normal.outputs = [{
        criteria = "Unknown 0x1400 0x00000000";
        position = "0,0";
        status = "enable";
      }];
      workdesk.outputs = [
        {
          criteria = "Unknown 0x1400 0x00000000";
          status = "enable";
          position = "960,2160";
        }
        {
          criteria = "Samsung Electric Company LF32TU87 HCPRA06514";
          status = "enable";
          position = "0,0";
        }
      ];
    };
  };
}
