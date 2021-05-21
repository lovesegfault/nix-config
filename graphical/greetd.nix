{ config, lib, pkgs, ... }: {
  environment.etc."greetd/environments".text = ''
    ${lib.optionalString config.programs.sway.enable "sway"}
    ${lib.optionalString config.services.xserver.windowManager.i3.enable "startx ~/.xsession"}
  '';

  services.greetd =
    let
      theme = "${pkgs.ayu-theme-gtk}/share/themes/Ayu-Dark/gtk-3.0/gtk.css";
      greetdSwayCfg = pkgs.writeText "sway-config" ''
        exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -s ${theme} -l; ${pkgs.sway}/bin/swaymsg exit"

        bindsym Mod4+shift+e exec ${pkgs.sway}/bin/swaynag \
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
          command = "${pkgs.sway}/bin/sway --config ${greetdSwayCfg}";
        };
      };
    };
}
