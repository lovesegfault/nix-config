{ config, pkgs, ... }: {
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaybg
      swayidle
      swaylock
      wl-clipboard
      xwayland
    ];
    extraSessionCommands = ''
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_WAYLAND_FORCE_DPI=physical
      export SDL_VIDEODRIVER=wayland
      export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1 sway
      export _JAVA_AWT_WM_NONREPARENTING=1
      export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
    '';
    wrapperFeatures.gtk = true;
  };

  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
}
