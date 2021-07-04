{ lib, ... }: {
  environment.etc."sway/config.d/inputs.conf".text = ''
    input "1241:4611:HID_04d9:1203" {
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
    output "<Unknown> <Unknown> " {
      mode 480x800@60Hz
      subpixel rgb
      transform 90
    }
  '';

  home-manager.users.bemeurer.wayland.windowManager.sway = {
    config = {
      gaps = lib.mkForce null;
      modifier = lib.mkForce "Mod1";
    };
    extraSessionCommands = ''
      export WLR_DRM_DEVICES=/dev/dri/card1
    '';
  };
}
