{ pkgs, lib, ... }:
let
  common = rec {
    colors =
      let
        foreground_focused = "#E6B450";
        border_focused = "#273747";
        foreground_inactive = "#B3B1AD";
        border_inactive = "#0A0E14";
      in
      {
        focused = {
          border = border_focused;
          background = border_focused;
          text = foreground_focused;
          childBorder = border_focused;
          indicator = border_focused;
        };
        unfocused = {
          border = border_inactive;
          background = border_inactive;
          text = foreground_inactive;
          childBorder = border_inactive;
          indicator = border_inactive;
        };
        focusedInactive = {
          border = border_inactive;
          background = border_inactive;
          text = foreground_inactive;
          childBorder = border_inactive;
          indicator = border_inactive;
        };
      };

    defaultWorkspace = "workspace 1";

    floating = {
      inherit modifier;
      border = 0;
    };

    focus.followMouse = false;

    fonts = {
      names = [ "monospace" ];
      size = 10.0;
    };

    gaps = {
      inner = 10;
      outer = 5;
      smartBorders = "on";
      smartGaps = true;
    };

    keybindings =
      let
        execSpawn = cmd: "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${cmd}";
      in
      lib.mkOptionDefault {
        "${modifier}+0" = "workspace 10";
        "${modifier}+Shift+0" = "move container to workspace 10";
        "${modifier}+comma" = "workspace prev";
        "${modifier}+period" = "workspace next";
        "Mod1+Tab" = "workspace next";
        "Mod4+Tab" = "workspace prev";
        "XF86AudioLowerVolume" = execSpawn "${lib.getExe pkgs.ponymix} decrease 1";
        "XF86AudioMicMute" = execSpawn "${lib.getExe pkgs.ponymix} -t source toggle";
        "XF86AudioMute" = execSpawn "${lib.getExe pkgs.ponymix} -t sink toggle";
        "XF86AudioNext" = execSpawn "${lib.getExe pkgs.playerctl} next";
        "XF86AudioPause" = execSpawn "${lib.getExe pkgs.playerctl} pause";
        "XF86AudioPlay" = execSpawn "${lib.getExe pkgs.playerctl} play";
        "XF86AudioPrev" = execSpawn "${lib.getExe pkgs.playerctl} previous";
        "XF86AudioRaiseVolume" = execSpawn "${lib.getExe pkgs.ponymix} increase 1";
        "XF86MonBrightnessDown" = execSpawn "${lib.getExe pkgs.brillo} -e -U 1";
        "XF86MonBrightnessUp" = execSpawn "${lib.getExe pkgs.brillo} -e -A 1";
      };

    modifier = "Mod1";

    window = {
      border = 0;
      commands = [
        {
          command = "floating enable, sticky enable";
          criteria.title = "Picture-in-Picture";
        }
        {
          command = "floating enable, sticky enable";
          criteria.title = ".*Sharing Indicator.*";
        }
        {
          command = "floating enable";
          criteria.title = "Plexamp";
        }
      ];
    };
  };
in
{
  xsession.windowManager.i3.config = common;
  wayland.windowManager.sway.config = common;
}
