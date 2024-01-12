{ lib, pkgs, ... }: {
  programs.sway.enable = true;

  home-manager.users.bemeurer = {
    wayland.windowManager.sway = {
      config = {
        output = {
          "Unknown XGIMI TV 0x00000001" = {
            mode = "3840x2160@60Hz";
            position = "0,0";
            scale = "2";
          };
        };
        startup = [
          { command = "${lib.getExe pkgs.ponymix} -t source mute"; }
          { command = "${lib.getExe pkgs.ponymix} -t sink mute"; }
        ];
      };
    };

    services.gammastep.settings.general = {
      brightness-day = 1.0;
      brightness-night = 1.0;
    };
  };
}
