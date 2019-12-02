{ config, pkgs, ... }: {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      alacritty
      gebaar-libinput
      grim
      light
      mako
      playerctl
      redshift-wlr
      slurp
      swaybg
      swayidle
      swaylock
      waybar
      wf-recorder
      wl-clipboard
      xwayland
    ];
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_FORCE_DPI=physical
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export SDL_VIDEODRIVER=wayland
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  services.xserver.displayManager.extraSessionFilePackages = [ pkgs.sway ];

  users.users.bemeurer.extraGroups = [ "input" "video" ];
}
