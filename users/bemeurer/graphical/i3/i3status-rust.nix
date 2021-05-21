{
  programs.i3status-rust = {
    enable = true;
    bars.top = {
      blocks = [
        {
          block = "sound";
          format = "{volume}";
        }
        {
          block = "net";
          format = "{ssid} ({signal_strength}%)";
          format_alt = "{ip}";
        }
        {
          block = "temperature";
          scale = "celsius";
          format = "{average}°C";
        }
        {
          block = "backlight";
        }
        # broken in 0.20.1
        # {
        #   block = "battery";
        #   format = "{percentage}%";
        #   allow_missing = true;
        #   hide_missing = true;
        # }
      ];
      icons = "awesome5";
      settings.theme = {
        name = "slick";
        overrides = {
          alternating_tint_bg = "#0A0E14";
          alternating_tint_fg = "#B3B1AD";
          critical_bg = "#FF3333";
          critical_fg = "#B3B1AD";
          good_bg = "#0A0E14";
          good_fg = "#C2D94C";
          idle_bg = "#0A0E14";
          idle_fg = "#B3B1AD";
          info_bg = "#0A0E14";
          info_fg = "#59C2FF";
          separator_bg = "#00010A";
          separator_fg = "#B3B1AD";
          warning_bg = "#0A0E14";
          warning_fg = "#E6B450";
        };
      };
    };
  };
}
