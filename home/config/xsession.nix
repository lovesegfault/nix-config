{ lib, config, pkgs, ... }:
{
  xsession = if config.isDesktop then
  {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        bars  = [
          {
            colors.background = "#424242";
            fonts = [ "FontAwesome 10" "Hack 10" ];
            position = "top";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
            workspaceNumbers = false;
          }
        ];
        floating.modifier = config.xsession.windowManager.i3.config.modifier;
        fonts = [ "FontAwesome 8" "Hack 8"];
        gaps = {
          inner = 5;
          outer = 5;
          smartBorders = "on";
          smartGaps = false;
        };
        keybindings = let
          # chkbd = "${config.home.homeDirectory}/bin/chkbd";
          chkbd = "";
          clip = "${pkgs.wl-clipboard}/bin/wl-copy";
          light = "${pkgs.light}/bin/light";
          menu = "${pkgs.rofi}/bin/rofi";
          mod = config.xsession.windowManager.i3.config.modifier;
          nag = "${config.xsession.windowManager.i3.package}/bin/i3-nagbar";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          # passmenu = "${config.home.homeDirectory}/bin/passmenu";
          passmenu = "";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${clip}";
          term = "${pkgs.alacritty}/bin/alacritty";
        in
        lib.mkOptionDefault {
          "${mod}+0" = "workspace 10:κ";
          "${mod}+1" = "workspace 1:α";
          "${mod}+2" = "workspace 2:β";
          "${mod}+3" = "workspace 3:γ";
          "${mod}+4" = "workspace 4:δ";
          "${mod}+5" = "workspace 5:ε";
          "${mod}+6" = "workspace 6:ζ";
          "${mod}+7" = "workspace 7:η";
          "${mod}+8" = "workspace 8:θ";
          "${mod}+9" = "workspace 9:ι";
          "${mod}+Down" = "focus down";
          "${mod}+Left" = "focus left";
          "${mod}+Print" = "exec ${screenshot}";
          "${mod}+Return" = "exec ${term}";
          "${mod}+Right" = "focus right";
          "${mod}+Shift+0" = "move container to workspace 10:κ";
          "${mod}+Shift+1" = "move container to workspace 1:α";
          "${mod}+Shift+2" = "move container to workspace 2:β";
          "${mod}+Shift+3" = "move container to workspace 3:γ";
          "${mod}+Shift+4" = "move container to workspace 4:δ";
          "${mod}+Shift+5" = "move container to workspace 5:ε";
          "${mod}+Shift+6" = "move container to workspace 6:ζ";
          "${mod}+Shift+7" = "move container to workspace 7:η";
          "${mod}+Shift+8" = "move container to workspace 8:θ";
          "${mod}+Shift+9" = "move container to workspace 9:ι";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+e" = "${nag} -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+Shift+q" = "kill";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+Up" = "focus up";
          "${mod}+XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -1%";
          "${mod}+XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "${mod}+XF86AudioNext" = "exec ${playerctl} next";
          "${mod}+XF86AudioPlay" = "exec ${playerctl} play-pause";
          "${mod}+XF86AudioPrev" = "exec ${playerctl} previous";
          "${mod}+XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +1%";
          "${mod}+XF86MonBrightnessDown" = "exec ${light} -U 1";
          "${mod}+XF86MonBrightnessUp" = "exec ${light} -A 1";
          "${mod}+a" = "focus parent";
          "${mod}+b" = "split h";
          "${mod}+bracketleft" = "workspace prev";
          "${mod}+bracketright" = "workspace next";
          "${mod}+d" = "exec --no-startup-id ${menu}";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+m" = "scratchpad show";
          "${mod}+p" = "exec --no-startup-id ${passmenu}";
          "${mod}+r" = "mode \"resize\"";
          "${mod}+s" = "layout stacking";
          "${mod}+space" = "exec ${chkbd}";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";
          "Mod1+Tab" = "workspace next";
          "Mod4+Tab" = "workspace prev";
          #"${mod}+" = "";
        };
        modifier = "Mod4";
        startup = let
            sysconfig = (import <nixpkgs/nixos> {
              system = config.nixpkgs.system;
            }).config;
          in
        [
          { command = "${pkgs.xorg.xhost}/bin/xhost +local:";
            always = false;
            notification = false;
          }
          { command = "${pkgs.xorg.setxkbmap}/bin/setxkbmap ${sysconfig.i18n.consoleKeyMap}";
            always = false;
            notification = false;
          }
          { command = "${pkgs.feh}/bin/feh --bg-scale ${config.bgImage}";
            always = true;
            notification = false;
          }
        ];
        window.commands = [
          {
            command = "border pixel 2";
            criteria = { class = "^.*"; };
          }
        ];
      };
    };
  } else
  {
    enable = false;
  };
}
