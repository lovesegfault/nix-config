{
  home-manager.users.bemeurer.wayland.windowManager.sway = {
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

  programs.sway.enable = true;
}
