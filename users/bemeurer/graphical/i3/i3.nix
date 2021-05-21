{ config, lib, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      bars = [{
        colors = {
          activeWorkspace = {
            background = "#1F2430";
            border = "#1F2430";
            text = "#B3B1AD";
          };
          background = "#0A0E14";
          focusedWorkspace = {
            background = "#1F2430";
            border = "#1F2430";
            text = "#B3B1AD";
          };
          inactiveWorkspace = {
            background = "#0A0E14";
            border = "#0A0E14";
            text = "#B3B1AD";
          };
          separator = "#73D0FF";
          statusline = "#B3B1AD";
          urgentWorkspace = {
            background = "#FF3333";
            border = "#FF3333";
            text = "#0A0E14";
          };
        };
        fonts = {
          names = [ "Hack" "Font Awesome 5 Free" ];
          style = "Regular";
          size = 12.0;
        };
        position = "top";
        statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
      }];

      keybindings =
        let
          execSpawn = cmd: "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${cmd}";
          modifier = config.xsession.windowManager.i3.config.modifier;
          terminal = config.xsession.windowManager.i3.config.terminal;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = execSpawn "${terminal}";
          "${modifier}+d" = execSpawn "${pkgs.drunmenu-x11}/bin/drunmenu";
          "${modifier}+m" = execSpawn "${pkgs.emojimenu-x11}/bin/emojimenu";
          "${modifier}+t" = execSpawn "${pkgs.otpmenu-x11}/bin/otpmenu";
          "${modifier}+p" = execSpawn "${pkgs.passmenu-x11}/bin/passmenu";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+q" = execSpawn "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
          # "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
        };

      startup = [{
        command = ''
          ${pkgs.systemd}/bin/systemctl --user import-environment; \
            systemctl --user start i3-session.target
        '';
        always = false;
        notification = false;
      }];

      terminal = "${config.programs.alacritty.package}/bin/alacritty";

      window.commands = [
        { command = "floating enable"; criteria.class = "feh"; }
      ];
    };
  };
}
