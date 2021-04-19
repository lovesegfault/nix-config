{
  home-manager.users.bemeurer.wayland.windowManager.sway = {
    extraSessionCommands = ''
      export WLR_DRM_DEVICES=/dev/dri/card0
    '';
    config = {
      input = {
        "10730:258:Kinesis_Advantage2_Keyboard" = {
          xkb_layout = "us";
        };

        "1133:16511:Logitech_G502" = {
          accel_profile = "adaptive";
          natural_scroll = "enabled";
        };

        "1133:16495:Logitech_MX_Ergo" = {
          accel_profile = "adaptive";
          natural_scroll = "enabled";
        };

        "1133:45085:Logitech_MX_Ergo_Multi-Device_Trackball" = {
          accel_profile = "adaptive";
          natural_scroll = "enabled";
        };
      };
      output = {
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
      };
    };
    extraConfig = ''
      focus output DP-1
      workspace 0:α
    '';
  };
}
