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

    defaultWorkspace = "workspace number 1";

    floating = {
      inherit modifier;
      border = 0;
    };

    focus.followMouse = false;

    fonts = {
      names = [ "FontAwesome" "Hack" ];
      size = 10.0;
    };

    gaps = lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") {
      inner = 10;
      outer = 5;
      smartBorders = "on";
    };

    keybindings =
      let
        execSpawn = cmd: "exec --no-startup-id ${pkgs.spawn}/bin/spawn ${cmd}";
      in
      lib.mkOptionDefault {
        # fancy workspace names
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";
        # normal ones
        "Mod1+Tab" = " workspace next";
        "Mod4+Tab" = " workspace prev";
        "Mod4+comma" = " workspace prev";
        "Mod4+period" = " workspace next";
        "XF86AudioLowerVolume" = execSpawn "${pkgs.ponymix}/bin/ponymix decrease 1";
        "XF86AudioMicMute" = execSpawn "${pkgs.ponymix}/bin/ponymix -t source toggle";
        "XF86AudioMute" = execSpawn "${pkgs.ponymix}/bin/ponymix -t sink toggle";
        "XF86AudioNext" = execSpawn "${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPause" = execSpawn "${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioPlay" = execSpawn "${pkgs.playerctl}/bin/playerctl play";
        "XF86AudioPrev" = execSpawn "${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioRaiseVolume" = execSpawn "${pkgs.ponymix}/bin/ponymix increase 1";
        "XF86MonBrightnessDown" = execSpawn "${pkgs.brillo}/bin/brillo -e -U 0.5";
        "XF86MonBrightnessUp" = execSpawn "${pkgs.brillo}/bin/brillo -e -A 0.5";
      };

    modifier = if pkgs.hostPlatform.system == "aarch64-linux" then "Mod1" else "Mod4";

    window.border = 0;
  };
in
{
  xsession.windowManager.i3.config = common;
  wayland.windowManager.sway.config = common;
}
