{ pkgs, ... }: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      nlSupport = false;
      iwSupport = true;
      mpdSupport = true;
      githubSupport = true;
    };
    config =
      let
        background = "#0D1016";
        background-alt = "#273747";
        foreground = "#B3B1AD";
        foreground-alt = "#E6B450";
        alert = "#FF3333";
      in
      {
        colors = { inherit background background-alt foreground foreground-alt alert; };

        "bar/top" = rec {
          width = "100%";
          radius = 0;

          inherit background foreground;

          font-size = "12";

          font-0 = "monospace:style=Regular:size=${font-size};5";
          font-1 = "emoji:style=Regular:scale=10;4";

          padding = 1;
          # https://en.wikipedia.org/wiki/Thin_space
          separator = " ";
          module-margin = 0;

          modules-left = [ "i3" ];
          modules-center = [ "date" ];
          modules-right = [
            "pulseaudio"
            "network"
            "temperature"
            "brillo"
            "battery"
          ];

          monitor = "\${env:MONITOR:}";

          tray-padding = 1;
          tray-position = "right";
          tray-maxsize = 512;

          scroll-up = "${pkgs.brillo}/bin/brillo -e -A 0.5";
          scroll-down = "${pkgs.brillo}/bin/brillo -e -U 0.5";
        };

        "module/brillo" = {
          type = "custom/script";

          format = "<label> ";
          exec = ''echo "$(${pkgs.brillo}/bin/brillo)"%'';
          format-padding = 1;
          format-background = background;
        };

        "module/battery" = {
          type = "internal/battery";
          full-at = 99;

          time-format = "%H:%M";
          format-charging = "<animation-charging> <label-charging>";
          format-charging-background = background;
          format-charging-padding = 1;
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-background = background;
          format-discharging-padding = 1;
          format-full = "<ramp-capacity> <label-full>";
          format-full-background = background;
          format-full-padding = 1;

          label-charging = " %percentage%%";
          label-discharging = "%percentage%%";
          label-full = "%percentage%%";

          ramp-capacity-0 = " ";
          ramp-capacity-1 = " ";
          ramp-capacity-2 = " ";
          ramp-capacity-3 = " ";
          ramp-capacity-4 = " ";

          animation-charging-0 = " ";
          animation-charging-1 = " ";
          animation-charging-2 = " ";
          animation-charging-3 = " ";
          animation-charging-4 = " ";
          animation-charging-framerate = 750;
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%H:%M | %Z";
          time = "%F";
          label = "%time% | %date%";
        };

        "module/i3" = {
          type = "internal/i3";
          wrapping-scroll = false;
          index-sort = true;

          label-focused = "%name%";
          label-focused-foreground = foreground-alt;
          label-focused-background = background-alt;
          label-focused-padding = 1;

          label-unfocused = "%name%";
          label-unfocused-padding = 1;

          label-visible = "%name%";
          label-visible-padding = 1;

          label-urgent = "%name%";
          label-urgent-background = alert;
          label-urgent-padding = 1;
        };

        "module/network" = {
          type = "internal/network";
          interface = "wlan0";
          interval = 5;

          format-connected = " <label-connected>";
          format-connected-background = background;
          format-connected-padding = 1;
          format-disconnected = "<label-disconnected>";
          format-disconnected-background = alert;
          format-disconnected-padding = 1;

          label-connected = "%essid% %signal%%";
          label-disconnected = "⚠ Disconnected";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<ramp-volume> <label-volume>";
          format-volume-background = background;
          format-volume-padding = 1;
          format-muted = "<label-muted>";
          format-muted-background = background;
          format-muted-padding = 1;

          label-volume = "%percentage%%";
          label-muted = "";

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";

          click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
          scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
        };

        "module/temperature" = rec {
          type = "internal/temperature";

          interval = 5;

          base-temperature = 40;
          warn-temperature = 80;
          units = true;

          format = "<ramp><label>";
          format-background = background;

          label = "%temperature-c%";
          label-background = background;
          label-padding = 1;

          format-warn = "<ramp><label-warn>";
          format-warn-background = alert;

          label-warn = label;
          label-warn-background = alert;
          label-warn-padding = 1;

          ramp-0 = " ";
          ramp-1 = " ";
          ramp-2 = " ";
        };
      };

    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils-full}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload top &
      done
    '';
  };
}
