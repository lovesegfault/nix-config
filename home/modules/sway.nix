{ pkgs, ... }: {
  imports = [ ../../share/pkgs/passmenu.nix ../../share/pkgs/prtsc.nix ../../share/pkgs/swaymenu.nix ];

  xdg.configFile.gebaar = {
    target = "gebaar/gebaard.toml";
    text = ''
      [commands.swipe.three]
      left_up = ""
      right_up = ""
      up = ""
      left_down = ""
      right_down = ""
      down = ""
      left = "swaymsg \"workspace next\""
      right = "swaymsg \"workspace prev\""
    '';
  };

  xdg.configFile.sway = {
    target = "sway/config";
    text = let
      passmenu = "${pkgs.passmenu}/bin/passmenu";
      prtsc = "${pkgs.prtsc}/bin/prtsc";
      swaymenu = "${pkgs.swaymenu}/bin/swaymenu";
      term = "alacritty";
      menu = "${term} -d 80 20 -t swaymenu -e ${swaymenu}";
      waybar = "waybar";
      mako = "mako";
    in ''
      ### Variables
      set $mod Mod4
      set $left h
      set $down j
      set $up k
      set $right l
      for_window [title="swaymenu"] floating enable, border pixel 5, sticky enable
      for_window [title="passmenu"] floating enable, border pixel 5, sticky enable

      ### Output configuration
      output * bg ~/pictures/walls/clouds.jpg fill
      output eDP-1 resolution 3840x2160 position 0,0 scale 2 subpixel rgb
      # output eDP-1 resolution 1920x1080 position 0,0 scale 1 subpixel rgb
      output LVDS-1 resolution 1920x1080 position 0,0 scale 1 subpixel rgb

      ### Idle configuration
      exec swayidle -w \
               timeout 300 'swaylock -f -c 000000' \
               timeout 600 'swaymsg "output * dpms off"' \
                    resume 'swaymsg "output * dpms on"' \
               before-sleep 'swaylock -f -c 000000'


      ### Input configuration
      input "1:1:AT_Translated_Set_2_keyboard" {
          xkb_layout us
          repeat_rate 70
      }

      input "2131:308:LEOPOLD_Mini_Keyboard" {
          xkb_layout us
      }

      input "2:7:SynPS/2_Synaptics_TouchPad" {
          accel_profile adaptive
          click_method button_areas
          dwt disabled
          natural_scroll enabled
          scroll_method two_finger
          tap enabled
      }

      input "1739:31251:SYNA2393:00_06CB:7A13_Touchpad" {
          accel_profile adaptive
          click_method button_areas
          dwt disabled
          natural_scroll enabled
          scroll_method two_finger
          tap enabled
      }

      input "2:8:AlpsPS/2_ALPS_DualPoint_TouchPad" {
          accel_profile adaptive
          click_method button_areas
          dwt disabled
          natural_scroll enabled
          scroll_method two_finger
          tap enabled
      }

      input "2:10:TPPS/2_Elan_TrackPoint" {
          accel_profile adaptive
          dwt enabled
      }

      input "1133:16495:Logitech_MX_Ergo" {
          accel_profile adaptive
          click_method button_areas
          natural_scroll enabled
      }

      ### Key bindings
      #
      # Basics:
      #
          # start a terminal
          bindsym $mod+Return exec ${term}

          # kill focused window
          bindsym $mod+Shift+q kill

          # start your launcher
          bindsym $mod+d exec ${menu}
          bindsym $mod+p exec ${passmenu}

          bindsym Print exec ${prtsc}
          bindsym XF86MonBrightnessUp exec light -A 1
          bindsym XF86MonBrightnessDown exec light -U 1
          bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +1%
          bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -1%
          bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
          bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bindsym XF86Display exec swaylock -f
          bindsym XF86AudioPlay exec playerctl play
          bindsym XF86AudioPause exec playerctl pause
          bindsym XF86AudioNext exec playerctl next
          bindsym XF86AudioPrev exec playerctl previous

          # Drag floating windows by holding down $mod and left mouse button.
          # Resize them with right mouse button + $mod.
          # Despite the name, also works for non-floating windows.
          # Change normal to inverse to use left mouse button for resizing and right
          # mouse button for dragging.
          floating_modifier $mod normal

          # reload the configuration file
          bindsym $mod+Shift+c reload

          # exit sway (logs you out of your Wayland session)
          bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
      #
      # Moving around:
      #
          # Move your focus around
          bindsym $mod+$left focus left
          bindsym $mod+$down focus down
          bindsym $mod+$up focus up
          bindsym $mod+$right focus right
          # or use $mod+[up|down|left|right]
          bindsym $mod+Left focus left
          bindsym $mod+Down focus down
          bindsym $mod+Up focus up
          bindsym $mod+Right focus right

          # _move_ the focused window with the same, but add Shift
          bindsym $mod+Shift+$left move left
          bindsym $mod+Shift+$down move down
          bindsym $mod+Shift+$up move up
          bindsym $mod+Shift+$right move right
          # ditto, with arrow keys
          bindsym $mod+Shift+Left move left
          bindsym $mod+Shift+Down move down
          bindsym $mod+Shift+Up move up
          bindsym $mod+Shift+Right move right
      #
      # Workspaces:
      #
          # switch to workspace
          bindsym $mod+1 workspace 1:α
          bindsym $mod+2 workspace 2:β
          bindsym $mod+3 workspace 3:γ
          bindsym $mod+4 workspace 4:δ
          bindsym $mod+5 workspace 5:ε
          bindsym $mod+6 workspace 6:ζ
          bindsym $mod+7 workspace 7:η
          bindsym $mod+8 workspace 8:θ
          bindsym $mod+9 workspace 9:ι
          bindsym $mod+0 workspace 10:κ
          # move focused container to workspace
          bindsym $mod+Shift+1 move container to workspace 1:α
          bindsym $mod+Shift+2 move container to workspace 2:β
          bindsym $mod+Shift+3 move container to workspace 3:γ
          bindsym $mod+Shift+4 move container to workspace 4:δ
          bindsym $mod+Shift+5 move container to workspace 5:ε
          bindsym $mod+Shift+6 move container to workspace 6:ζ
          bindsym $mod+Shift+7 move container to workspace 7:η
          bindsym $mod+Shift+8 move container to workspace 8:θ
          bindsym $mod+Shift+9 move container to workspace 9:ι
          bindsym $mod+Shift+0 move container to workspace 10:κ
          # Note: workspaces can have any name you want, not just numbers.
          # We just use 1-10 as the default.
          bindsym Mod1+Tab workspace next
          bindsym $mod+Tab workspace prev
          bindsym $mod+period workspace next
          bindsym $mod+comma workspace prev
      #
      # Layout stuff:
      #
          font pango:Hack 8
          gaps inner 5
          gaps outer 10
          smart_borders on
          default_border none
          default_floating_border normal

          client.focused #30535F #30535F #F0BC8D #A43C0F #A43C0F
          client.unfocused #00122A #00122A #F0BC8D #A43C0F #A43C0F
          client.urgent #A43C0F #A43C0F #000000 #A43C0F #A43C0F

          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits
          # respectively.
          bindsym $mod+b splith
          bindsym $mod+v splitv

          # Switch the current container between different layout styles
          bindsym $mod+s layout stacking
          bindsym $mod+w layout tabbed
          bindsym $mod+e layout toggle split

          # Make the current focus fullscreen
          bindsym $mod+f fullscreen

          # Toggle the current focus between tiling and floating mode
          bindsym $mod+Shift+space floating toggle

          # Swap focus between the tiling area and the floating area
          bindsym $mod+space focus mode_toggle

          # move focus to the parent container
          bindsym $mod+a focus parent
      #
      # Scratchpad:
      #
          # Sway has a "scratchpad", which is a bag of holding for windows.
          # You can send windows there and get them back later.

          # Move the currently focused window to the scratchpad
          bindsym $mod+Shift+minus move scratchpad

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          bindsym $mod+minus scratchpad show
      #
      # Resizing containers:
      #
      mode "resize" {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers height
          # down will grow the containers height
          bindsym $left resize shrink width 10px
          bindsym $down resize grow height 10px
          bindsym $up resize shrink height 10px
          bindsym $right resize grow width 10px

          # ditto, with arrow keys
          bindsym Left resize shrink width 10px
          bindsym Down resize grow height 10px
          bindsym Up resize shrink height 10px
          bindsym Right resize grow width 10px

          # return to default mode
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      bindsym $mod+r mode "resize"

      ### Status Bar:
      bar {
          font pango: Hack, FontAwesome 10
          swaybar_command waybar
      }

      exec "dbus-update-activation-environment --systemd DISPLAY"
      exec "gebaard"
      exec "mako"
      exec "pactl set-sink-mute @DEFAULT_SINK@ true"
      exec "pactl set-source-mute @DEFAULT_SOURCE@ true"
      exec "redshift"
      exec "systemctl --user start gnome-keyring"

      include /etc/sway/config.d/*
    '';
  };
}
