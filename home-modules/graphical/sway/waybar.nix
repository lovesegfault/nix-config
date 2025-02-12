{ lib, pkgs, ... }:
{
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override { pulseSupport = true; };
    settings.main = {
      gtk-layer-shell = true;
      layer = "top";
      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "pulseaudio"
        "idle_inhibitor"
        "network"
        "temperature"
        "backlight"
        "battery"
        "tray"
      ];
      "sway/workspaces" = {
        all-outputs = true;
        format = "{name}";
      };
      "sway/mode" = {
        format = ''<span style="italic">{}</span>'';
      };

      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "󰋎";
          headset = "󰋎";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
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
        format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀";
        format-linked = "{ifname} (No IP) 󰌘";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      temperature = {
        critical-threshold = lib.mkDefault 90;
        format = "{temperatureC}°C {icon}";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      backlight = {
        device = "intel_backlight";
        format = "{percent}% {icon}";
        format-icons = [
          "󱩎"
          "󱩏"
          "󱩐"
          "󱩑"
          "󱩒"
          "󱩓"
          "󱩔"
          "󱩕"
          "󱩖"
          "󰛨"
        ];
        on-scroll-up = "${pkgs.brillo}/bin/brillo -e -A 0.5";
        on-scroll-down = "${pkgs.brillo}/bin/brillo -e -U 0.5";
      };
      battery = {
        bat = "BAT0";
        states = {
          good = 90;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
      };
      clock = {
        tooltip-format = "{calendar}";
        format = "󰃭 {:%F | 󰥔 %H:%M | 󰇧 %Z}";
      };
      tray = {
        icon-size = lib.mkDefault 20;
        spacing = lib.mkDefault 5;
      };
    };

    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };
}
