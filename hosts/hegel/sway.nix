{
  environment.etc."sway/config.d/inputs.conf".text = ''
    input "10730:258:Kinesis_Advantage2_Keyboard" {
      xkb_layout us
    }

    input "1133:16495:Logitech_MX_Ergo" {
      accel_profile adaptive
      natural_scroll enabled
    }

    input "1133:16511:Logitech_G502" {
      accel_profile adaptive
      natural_scroll enabled
    }

    input "1133:45085:Logitech_MX_Ergo_Multi-Device_Trackball" {
      accel_profile adaptive
      natural_scroll enabled
    }
  '';

  environment.etc."sway/config.d/outputs.conf".text = ''
    output "Goldstar Company Ltd LG Ultra HD 0x00000B08" {
      adaptive_sync on
      mode 3840x2160@60Hz
      position 0,720
      subpixel rgb
    }

    output "Goldstar Company Ltd LG Ultra HD 0x00009791" {
      adaptive_sync on
      mode 3840x2160@60Hz
      position 3840,0
      subpixel rgb
      transform 270
    }

    workspace 1 output "Goldstar Company Ltd LG Ultra HD 0x00000B08"
    workspace 0 output "Goldstar Company Ltd LG Ultra HD 0x00009791"
    focus output "Goldstar Company Ltd LG Ultra HD 0x00000B08"
  '';

  home-manager.users.bemeurer.wayland.windowManager.sway.extraSessionCommands = ''
    export WLR_DRM_DEVICES=/dev/dri/card0
  '';
}
