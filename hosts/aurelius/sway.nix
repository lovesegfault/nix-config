{ lib, ... }: {
  environment.etc."sway/config.d/inputs.conf".text = ''
    input "1:1:AT_Translated_Set_2_keyboard" {
      xkb_layout us
      repeat_rate 70
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
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us";
          repeat_rate = "70";
        };
      };
      output = {
        "DSI-1" = {
          mode = "480x800@60Hz";
          position = "0,0";
          subpixel = "rgb";
          transform = "90";
        };
      };
    };
  };

  programs.sway.enable = true;
}
