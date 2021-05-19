{ config, lib, pkgs, ... }: {
  xsessions.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = lib.recursiveUpdate
      (import ../common.nix { inherit pkgs lib; })
      {
        keybindings =
          let
            execSpawn = cmd: "exec ${pkgs.spawn}/bin/spawn ${cmd}";
            modifier = config.xsessions.windowManager.i3.config.modifier;
            terminal = config.xsessions.windowManager.i3.config.terminal;
          in
          lib.mkOptionDefault {
            # normal ones
            "${modifier}+Return" = execSpawn "${terminal}";
            "${modifier}+d" = execSpawn "${pkgs.drunmenu-x11}/bin/drunmenu";
            "${modifier}+m" = execSpawn "${pkgs.emojimenu-x11}/bin/emojimenu";
            "${modifier}+t" = execSpawn "${pkgs.otpmenu-x11}/bin/otpmenu";
            "${modifier}+p" = execSpawn "${pkgs.passmenu-x11}/bin/passmenu";
            # "${modifier}+q" = execSpawn "${pkgs.swaylock}/bin/swaylock -f";
            # "Print" = execSpawn "${pkgs.screenshot}/bin/screenshot";
          };

        terminal = "${config.programs.alacritty.package}";

        window.commands = [
          { command = "floating enable, sticky enable"; criteria.title = "Picture-in-Picture"; }
          { command = "floating enable"; criteria.class = "feh"; }
        ];
      };
  };
}
