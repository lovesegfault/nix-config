{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;

    # https://github.com/nix-community/home-manager/issues/5311
    checkConfig = false;

    config = {
      bars = [ ];

      input = {
        "type:keyboard".xkb_options = "caps:escape";
      };

      keybindings =
        let
          execSpawn = cmd: "exec ${pkgs.spawn}/bin/spawn ${cmd}";
          inherit (config.wayland.windowManager.sway.config) modifier terminal;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = execSpawn terminal;
          "${modifier}+d" = execSpawn "${pkgs.drunmenu-wayland}/bin/drunmenu";
          "${modifier}+m" = execSpawn "${pkgs.emojimenu-wayland}/bin/emojimenu";
          "${modifier}+o" = execSpawn "${pkgs.screenocr}/bin/screenocr";
          "${modifier}+q" = execSpawn "swaylock -f";
          "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
        };

      terminal = lib.getExe pkgs.foot;

      window.commands = [
        {
          command = "floating enable";
          criteria.app_id = "imv";
        }
      ];
    };

    extraConfig = ''
      include /etc/sway/config.d/*
    '';

    extraOptions = [ "--unsupported-gpu" ];

    extraSessionCommands = ''
      export LIBSEAT_BACKEND="logind"

      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export NIXOS_OZONE_WL=1

      export MOZ_DBUS_REMOTE=1
      export MOZ_USE_XINPUT2=1

      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_WAYLAND_FORCE_DPI=physical

      export _JAVA_AWT_WM_NONREPARENTING=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"

      export WLR_RENDERER=vulkan
    '';

    systemd.enable = true;
    wrapperFeatures.gtk = true;
  };
}
