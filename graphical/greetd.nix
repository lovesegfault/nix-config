{ config, lib, pkgs, ... }: {
  environment.etc."greetd/environments".text = ''
    ${lib.optionalString config.programs.sway.enable "systemd-cat -t sway sway"}
    ${lib.optionalString config.services.xserver.windowManager.i3.enable "systemd-cat -t i3 startx ~/.xsession"}
  '';

  services.greetd =
    let
      theme = "${pkgs.ayu-theme-gtk}/share/themes/Ayu-Dark/gtk-3.0/gtk.css";
      swayMin = pkgs.sway.override {
        withBaseWrapper = false;
        withGtkWrapper = false;
        dbusSupport = false;
      };
      gtkgreetSwayCfg = pkgs.writeText "sway-config" ''
        exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -s ${theme} -l; ${swayMin}/bin/swaymsg exit"

        bindsym Mod4+shift+e exec ${swayMin}/bin/swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'

        include /etc/sway/config.d/*
      '';
    in
    {
      enable = true;
      vt = 7;
      settings = {
        default_session = {
          command = "${swayMin}/bin/sway --unsupported-gpu --config ${gtkgreetSwayCfg}";
        };
      };
    };
}
