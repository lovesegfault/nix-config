{ pkgs, lib, ... }:
let
  common = rec {
    defaultWorkspace = "workspace 1";

    floating = {
      inherit modifier;
      border = 0;
    };

    focus.followMouse = false;

    gaps = {
      inner = 10;
      outer = 5;
      smartBorders = "on";
      smartGaps = true;
    };

    keybindings = lib.mkOptionDefault {
      "${modifier}+0" = "workspace 10";
      "${modifier}+Shift+0" = "move container to workspace 10";
      "${modifier}+comma" = "workspace prev";
      "${modifier}+period" = "workspace next";
      "Mod1+Tab" = "workspace next";
      "Mod4+Tab" = "workspace prev";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${lib.getExe pkgs.ponymix} decrease 1";
      "XF86AudioMicMute" = "exec --no-startup-id ${lib.getExe pkgs.ponymix} -t source toggle";
      "XF86AudioMute" = "exec --no-startup-id ${lib.getExe pkgs.ponymix} -t sink toggle";
      "XF86AudioNext" = "exec --no-startup-id ${lib.getExe pkgs.playerctl} next";
      "XF86AudioPause" = "exec --no-startup-id ${lib.getExe pkgs.playerctl} pause";
      "XF86AudioPlay" = "exec --no-startup-id ${lib.getExe pkgs.playerctl} play";
      "XF86AudioPrev" = "exec --no-startup-id ${lib.getExe pkgs.playerctl} previous";
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${lib.getExe pkgs.ponymix} increase 1";
      "XF86MonBrightnessDown" = "exec --no-startup-id ${lib.getExe pkgs.brillo} -e -U 1";
      "XF86MonBrightnessUp" = "exec --no-startup-id ${lib.getExe pkgs.brillo} -e -A 1";
    };

    modifier = "Mod1";

    window = {
      titlebar = false;
      border = 0;
      commands = [
        {
          command = "floating enable, sticky enable";
          criteria.title = "Picture-in-Picture";
        }
        {
          command = "floating enable, sticky enable, resize set width 800 800";
          criteria.title = ".*Lock Screen.*";
          criteria.class = "1Password";
        }
        {
          command = "floating enable, sticky enable";
          criteria.title = ".*Sharing Indicator.*";
        }
        {
          command = "floating enable";
          criteria.title = "Plexamp";
        }
        {
          command = "floating enable, sticky enable";
          criteria.app_id = "polkit-gnome-authentication-agent-1";
        }
      ];
    };
  };
in
{
  xsession.windowManager.i3.config = common;
  wayland.windowManager.sway.config = common;
}
