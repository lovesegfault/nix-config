{ lib, ... }: {
  programs.sway.enable = true;

  home-manager.users.bemeurer = {
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

          "1386:21222:Wacom_HID_52E6_Finger" = {
            map_to_output = "eDP-1";
          };
        };
        output = {
          "Samsung Display Corp. 0x4167 Unknown" = {
            mode = "2880x1800@60Hz";
            position = "0,0";
            scale = "1";
            max_render_time = "3";
          };
        };
      };
      extraConfig = ''
        bindswitch --locked --reload lid:on output eDP-1 disable
        bindswitch --locked --reload lid:off output eDP-1 enable
      '';
      extraSessionCommands = ''
        export GDK_DPI_SCALE="1.3"
        export ELM_SCALE="1.3"
      '';
    };

    programs.waybar.settings.main.temperature.hwmon-path = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon2/temp1_input";

    services.gammastep.settings.general = {
      brightness-day = 1.0;
      brightness-night = 1.0;
    };
  };
}
