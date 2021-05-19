{ config, lib, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = lib.recursiveUpdate
      (import ../common.nix { inherit pkgs lib; })
      {
        startup = [
          { command = "${pkgs.feh}/bin/feh --bg-fill ~/.wall"; always = true; notification = false; }
        ];

        keybindings =
          let
            execSpawn = cmd: "exec ${pkgs.spawn}/bin/spawn ${cmd}";
            modifier = config.xsession.windowManager.i3.config.modifier;
            terminal = config.xsession.windowManager.i3.config.terminal;
          in
          lib.mkOptionDefault {
            # normal ones
            "${modifier}+Return" = execSpawn "${terminal}";
            "${modifier}+d" = execSpawn "${pkgs.drunmenu-x11}/bin/drunmenu";
            "${modifier}+m" = execSpawn "${pkgs.emojimenu-x11}/bin/emojimenu";
            "${modifier}+t" = execSpawn "${pkgs.otpmenu-x11}/bin/otpmenu";
            "${modifier}+p" = execSpawn "${pkgs.passmenu-x11}/bin/passmenu";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            # "${modifier}+q" = execSpawn "${pkgs.swaylock}/bin/swaylock -f";
            # "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
          };

        terminal = "${config.programs.alacritty.package}/bin/alacritty";

        window.commands = [
          { command = "floating enable, sticky enable"; criteria.title = "Picture-in-Picture"; }
          { command = "floating enable"; criteria.class = "feh"; }
        ];
      };
  };
}
