{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override { pulseSupport = true; };
    settings = {
      gtk-layer-shell = true;
      layer = "top";
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "clock" ];
      modules-right = [
        "pulseaudio"
        "idle_inhibitor"
        "network"
        "temperature"
      ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };

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
          on-click = "${pkgs.ponymix}/bin/ponymix -t sink toggle";
          on-scroll-up = "${pkgs.ponymix}/bin/ponymix increase 1";
          on-scroll-down = "${pkgs.ponymix}/bin/ponymix decrease 1";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        clock = {
          tooltip-format = "{calendar}";
          format = "{:%F | %H:%M | %Z}";
        };
        tray = {
          icon-size = 20;
          spacing = 5;
        };
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Iosevka, FontAwesome5Free;
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
    systemd.enable = true;
  };
}
