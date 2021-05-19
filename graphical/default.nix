{ config, lib, pkgs, ... }: {
  imports = [
    ./boot-silent.nix
    ./fonts.nix
    ./location.nix
  ];

  environment.systemPackages = with pkgs; [
    adwaita-qt
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
    qgnomeplatform
    qt5.qtwayland
    spawn
  ];

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.etc."greetd/environments".text = ''
    ${lib.optionalString config.programs.sway.enable "sway"}
    ${lib.optionalString config.services.xserver.windowManager.i3.enable "xinit"}
  '';

  services.greetd =
    let
      sway = pkgs.sway.override { withGtkWrapper = true; };
      greetdSwayCfg = pkgs.writeText "sway-config" ''
        exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; ${sway}/bin/swaymsg exit"

        bindsym Mod4+shift+e exec ${sway}/bin/swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'

        exec ${pkgs.systemd}/bin/systemctl --user import-environment
        include /etc/sway/config.d/*
      '';
    in
    {
      enable = true;
      settings = {
        default_session = {
          command = "${sway}/bin/sway --config ${greetdSwayCfg}";
        };
      };
    };

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      gtkUsePortal = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };
  };
}
