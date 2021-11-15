{ config, lib, pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [ ];

      keybindings =
        let
          execSpawn = cmd: "exec ${pkgs.spawn}/bin/spawn ${cmd}";
          modifier = config.wayland.windowManager.sway.config.modifier;
          terminal = config.wayland.windowManager.sway.config.terminal;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = execSpawn terminal;
          "${modifier}+d" = execSpawn "${pkgs.drunmenu-wayland}/bin/drunmenu";
          "${modifier}+m" = execSpawn "${pkgs.emojimenu-wayland}/bin/emojimenu";
          "${modifier}+o" = execSpawn "${pkgs.screenocr}/bin/screenocr";
          "${modifier}+t" = execSpawn "${pkgs.otpmenu-wayland}/bin/otpmenu";
          "${modifier}+p" = execSpawn "${pkgs.passmenu-wayland}/bin/passmenu";
          "${modifier}+q" = execSpawn "${pkgs.swaylock}/bin/swaylock -f";
          "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
        };

      output = { "*" = { bg = "${config.xdg.dataHome}/wall.png fill"; }; };

      terminal = "${config.programs.foot.package}/bin/foot";

      window.commands = [
        { command = "floating enable"; criteria.app_id = "imv"; }
      ];
    };

    extraConfig = ''
      include /etc/sway/config.d/*
    '';

    extraSessionCommands = ''
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=xcb
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_WAYLAND_FORCE_DPI=physical
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP="sway"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    systemdIntegration = true;
    wrapperFeatures.gtk = true;
  };
}
