{ pkgs, ... }:
let
  config = {
    layer = "top";
    modules-left = [ "sway/workspaces" "sway/mode" ];
    modules-right = [
      "pulseaudio"
      "idle_inhibitor"
      "network"
      # "cpu"
      # "memory"
      "temperature"
      "backlight"
      "battery"
      "clock"
      "tray"
    ];
    "sway/mode" = { format = ''<span style="italic">{}</span>''; };
    "sway/workspaces" = {
      all-outputs = true;
      format = "{name}:{icon}";
      format-icons = {
        urgent = "";
        focused = "";
        default = "";
      };
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      icon-size = 20;
      spacing = 5;
    };
    clock = {
      tooltip-format = "{:%Z}";
      format = "{:%F | %H:%M}";
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory = { format = "{}% "; };
    temperature = {
      thermal-zone = 1;
      critical-threshold = 80;
      format = "{temperatureC}°C {icon}";
      format-icons = [ "" "" "" ];
    };
    backlight = {
      format = "{percent}% {icon}";
      format-icons = [ "" "" ];
      on-scroll-up = "light -A 1";
      on-scroll-down = "light -U 1";
    };
    battery = {
      bat = "BAT0";
      states = {
        good = 90;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = [ "" "" "" "" "" ];
    };
    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = " {icon} {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphones = "";
        handsfree = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" "" ];
      };
      on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
      on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
    };
  };
in
{
  xdg.configFile.waybar = {
    target = "waybar/config";
    text = (builtins.toJSON config);
  };

  xdg.configFile.waybar-style = {
    target = "waybar/style.css";
    text = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Hack, FontAwesome5Free;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(0, 18, 42, 1);
          border-bottom: 0px rgba(100, 114, 125, 1);
          color: #FFFFFF;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #F0BC8D;
          border-bottom: 3px solid transparent;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          box-shadow: inherit;
          border-bottom: 3px solid #ffffff;
      }

      #workspaces button.focused {
          background-color: #17374A;
          border-bottom: 3px solid #ffffff;
      }

      #workspaces button.urgent {
          background-color: #A43C0F;
          color: #000000;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor {
        padding: 0 5px;
        margin: 0 2px;
        color: #ffffff;
      }

      #clock {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #battery {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #battery.charging {
          color: #F0BC8D;
          background-color: #17374A;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #A43C0F;
          color: #000000;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #memory {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #backlight {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #network {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #network.disconnected {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #pulseaudio {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #pulseaudio.muted {
          color: #F0BC8D;
          background-color: #30535F;
      }

      #temperature {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #temperature.critical {
          background-color: #A43C0F;
          color: #000000;
      }

      #tray {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #idle_inhibitor {
          color: #F0BC8D;
          background-color: #17374A;
      }

      #idle_inhibitor.activated {
          color: #F0BC8D;
          background-color: #30535F;
      }
    '';
  };
}
