{ config, lib, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      bars = [ ];

      keybindings =
        let
          execSpawn = cmd: "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${cmd}";
          inherit (config.xsession.windowManager.i3.config) modifier terminal;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = execSpawn terminal;
          "${modifier}+d" = execSpawn "${pkgs.drunmenu-x11}/bin/drunmenu";
          "${modifier}+m" = execSpawn "${pkgs.emojimenu-x11}/bin/emojimenu";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+q" = "exec --no-startup-id ${config.services.screen-locker.lockCmd}";
          "Print" = execSpawn "${pkgs.flameshot}/bin/flameshot gui";
        };

      startup = [
        {
          command = ''
            ${pkgs.systemd}/bin/systemctl --user import-environment DISPLAY; \
              ${pkgs.systemd}/bin/systemctl --user start i3-session.target
          '';
          always = false;
          notification = false;
        }
        {
          command = "${pkgs.systemd}/bin/systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.systemd}/bin/systemctl --user restart feh";
          always = true;
          notification = false;
        }
      ];

      terminal = "${lib.getExe config.programs.kitty.package} -1";

      window.commands = [
        { command = "floating enable"; criteria.class = "feh"; }
      ];
    };

    extraConfig = ''
      focus_wrapping no
    '';
  };
}
