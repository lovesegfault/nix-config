{ config, lib, pkgs, ... }: {
  environment.etc."greetd/environments".text = ''
    ${lib.optionalString config.programs.sway.enable "systemd-cat -t sway sway"}
    ${lib.optionalString config.services.xserver.windowManager.i3.enable "systemd-cat -t i3 startx ~/.xsession"}
  '';

  services.greetd =
    let
      theme = "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark/gtk-3.0/gtk.css";
      greetdSwayCfg = pkgs.writeText "sway-config" ''
        exec "${lib.getExe pkgs.greetd.gtkgreet} -s ${theme} -l; ${pkgs.sway-unwrapped}/bin/swaymsg exit"

        bindsym Mod4+shift+e exec ${pkgs.sway-unwrapped}/bin/swaynag \
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
          command = "${pkgs.sway-unwrapped}/bin/sway --unsupported-gpu --config ${greetdSwayCfg}";
        };
      };
    };
}
