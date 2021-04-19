{
  home-manager.users.bemeurer = { ... }: {
    wayland.windowManager.sway = {
      extraSessionCommands = ''
        export WLR_DRM_DEVICES=/dev/dri/card0
      '';
      config = {
        input = {
          "10730:258:Kinesis_Advantage2_Keyboard" = {
            xkb_layout = "us";
          };
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
          "Unknown 0x32EB 0x00000000" = {
            mode = "3840x2160@60Hz";
            position = "0,0";
            scale = "2";
            subpixel = "rgb";
          };
        };
      };
      extraConfig = ''
        bindswitch --locked --reload lid:on output eDP-1 disable
        bindswitch --locked --reload lid:off output eDP-1 enable
        focus output eDP-1
        workspace 0:α
      '';
    };
  };
}
