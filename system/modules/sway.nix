{ config, pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  nixpkgs.overlays = [ waylandOverlay ];

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      alacritty
      grim
      libinput-gestures
      light
      mako
      slurp
      swaybg
      swaylock
      swayidle
      waybar
      wl-clipboard
      wf-recorder
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
}
