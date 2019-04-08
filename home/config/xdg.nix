{ config, pkgs, ... }:
{
  xdg = if config.isDesktop then
  rec {
    enable = true;

    configFile.yubico = {
      executable = false;
      target = "${config.xdg.configHome}/Yubico/u2f_keys";
      text = "bemeurer:mGTYMD45F-CbfcJTGnRLD4jfq5U3jqbIMr_9ZgyoAIyoDfJjXjWFDvunyVQO1X9rxTCgSWUQfCJer4wIJPp6iw,04b557d0dba653ab6844f4118ea3fda4d429fe0ff112c6df3267a781a55d1cfd8549a4593a01a1b03f18ca13f1a656b2367336167a91c4091d7ba3b0f378163ab2";
    };

    configFile.mako = {
      executable = false;
      target = "${config.xdg.configHome}/mako/config";
      text = ''
        sort=-time
        font=Hack 10
        background-color=#2d2d2d
        text-color=#eaeaea
        border-color=#9a9a9a
        default-timeout=10000
      '';
    };

    configFile.sway = {
      executable = false;
      target = "${config.xdg.configHome}/sway/config";
      text = let
        bar = "${pkgs.i3status-rust}/bin/i3status-rs";
        barConfig = "${config.xdg.configFile.i3status-rust.target}";
        clip = "${pkgs.wl-clipboard}/bin/wl-copy";
        light = "${pkgs.light}/bin/light";
        swaylock = "${pkgs.swaylock}/bin/swaylock";
        swaymsg = "${pkgs.sway}/bin/swaymsg";
        swayidle = "${pkgs.swayidle}/bin/swayidle";
        swaynag = "${pkgs.sway}/bin/swaynag";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        rofi = "${pkgs.rofi}/bin/rofi";
        screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${clip}";
        terminal = "${pkgs.alacritty}/bin/alacritty";
      in
        ''
        # Read `man 5 sway` for a complete reference.
        #### Variables #####
        set $down j
        set $left h
        set $menu ${rofi} -show combi
        # set $menu ${terminal} -d 80 20 -t aopen --class aopen -e ~/bin/aopen
        set $mod Mod4
        set $right l
        set $up k
        for_window [app_id="aopen"] floating enable, border none

        #### Outputs ####
        output * bg ${config.bgImage} fill
        output eDP-1 resolution 3840x2160 position 0,0 scale 2

        #### Idle #####
        exec ${swayidle} \
            timeout 3600 '${swaylock} -c 000000' \
            timeout 7200 '${swaymsg} "output * dpms off"' \
            resume '${swaymsg} "output * dpms on"' \
            before-sleep '${swaylock} -c 000000'

        #### Inputs #####
        input "1:1:AT_Translated_Set_2_keyboard" {
            xkb_layout us
            xkb_numlock enabled
        }
        input "1386:20883:Wacom_Co.,Ltd._Pen_and_multitouch_sensor_Touchscreen" {
            accel_profile adaptive
            dwt disabled
            natural_scroll enabled
            scroll_method two_finger
            tap enabled
        }
        input "2131:308:LEOPOLD_Mini_Keyboard" {
            xkb_layout us
            xkb_numlock enabled
        }
        input "2:7:SynPS/2_Synaptics_TouchPad" {
            accel_profile adaptive
            click_method button_areas
            dwt enabled
            natural_scroll enabled
            scroll_method two_finger
            tap enabled
        }
        input "2:10:TPPS/2_Elan_TrackPoint" {
            accel_profile adaptive
            dwt enabled
            natural_scroll enabled
        }
        input "1133:16495:Logitech_MX_Ergo" {
            accel_profile adaptive
            click_method button_areas
            natural_scroll enabled
        }

        #### Key bindings ####
        bindsym $mod+Return exec --no-startup-id ${terminal}
        bindsym $mod+Shift+q kill
        bindsym $mod+d exec --no-startup-id $menu
        # FIXME
        bindsym $mod+p exec --no-startup-id ~/bin/passmenu
        bindsym Print exec ${screenshot}
        bindsym XF86MonBrightnessUp exec --no-startup-id ${light} -A 1
        bindsym XF86MonBrightnessDown exec --no-startup-id ${light} -U 1
        bindsym XF86AudioRaiseVolume exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +1%
        bindsym XF86AudioLowerVolume exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -1%
        bindsym XF86AudioMute exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle
        bindsym XF86AudioMicMute exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle
        bindsym XF86Tools exec --no-startup-id ${terminal} -e nvim
        bindsym XF86Display exec ${swaylock} -c 000000
        # Drag floating windows by holding down $mod and left mouse button.
        # Resize them with right mouse button + $mod.
        floating_modifier $mod normal
        # reload the configuration file
        bindsym $mod+Shift+c reload
        # exit sway (logs you out of your Wayland session)
        bindsym $mod+Shift+e exec ${swaynag} -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' '${swaymsg} exit'

        ####  Move around ####
        bindsym $mod+$left focus left
        bindsym $mod+$down focus down
        bindsym $mod+$up focus up
        bindsym $mod+$right focus right
        bindsym $mod+Left focus left
        bindsym $mod+Down focus down
        bindsym $mod+Up focus up
        bindsym $mod+Right focus right
        bindsym $mod+Shift+$left move left
        bindsym $mod+Shift+$down move down
        bindsym $mod+Shift+$up move up
        bindsym $mod+Shift+$right move right
        bindsym $mod+Shift+Left move left
        bindsym $mod+Shift+Down move down
        bindsym $mod+Shift+Up move up
        bindsym $mod+Shift+Right move right

        ##### Workspaces ####
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
        bindsym Mod1+Tab workspace next
        bindsym $mod+Tab workspace prev
        bindsym $mod+period workspace next
        bindsym $mod+comma workspace prev

        #### Layout ####
        font pango: Hack Regular 8
        gaps inner 5
        gaps outer 15
        smart_borders on
        default_border none
        default_floating_border normal
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
        #### Scratchpad ####
        # Sway has a "scratchpad", which is a bag of holding for windows.
        # You can send windows there and get them back later.
        # Move the currently focused window to the scratchpad
        bindsym $mod+Shift+minus move scratchpad
        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        bindsym $mod+minus scratchpad show
        #### Resizing containers ####
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
        ##### Status Bar ####
        # Read `man 5 sway-bar` for more information about this section.
        bar {
            position top
            font pango: Hack, FontAwesome 10
            status_command ${bar} ${barConfig}
            strip_workspace_numbers yes

            colors {
                    background #424242
            }
        }
        include /etc/sway/config.d/*
      '';
    };
    configFile.alacritty = {
      executable = false;
      target = "${config.xdg.configHome}/alacritty/alacritty.yml";
      text = ''
        env:
          TERM: screen-256color
        window:
          dimensions:
            columns: 0
            lines: 0
          padding:
            x: 0
            y: 0
          dynamic_padding: false
          decorations: none
          start_maximized: false

        scrolling:
          history: 0
          multiplier: 3
          faux_multiplier: 3
          auto_scroll: false

        tabspaces: 4

        font:
          normal:
            family: Hack
            style: Regular
          bold:
            family: Hack
            style: Bold
          italic:
            family: Hack
            style: Italic
          size: 10.0
          offset:
            x: 0
            y: 0
          glyph_offset:
            x: 0
            y: 0

          use_thin_strokes: true

        render_timer: false
        persistent_logging: false
        draw_bold_text_with_bright_colors: true

        colors:
          primary:
            background: '0x000000'
            foreground: '0xeaeaea'
            dim_foreground: '0x9a9a9a'
            bright_foreground: '0xffffff'
          normal:
            black:   '0x000000'
            red:     '0xd54e53'
            green:   '0xb9ca4a'
            yellow:  '0xe6c547'
            blue:    '0x7aa6da'
            magenta: '0xc397d8'
            cyan:    '0x70c0ba'
            white:   '0xeaeaea'
          bright:
            black:   '0x666666'
            red:     '0xff3334'
            green:   '0x9ec400'
            yellow:  '0xe7c547'
            blue:    '0x7aa6da'
            magenta: '0xb77ee0'
            cyan:    '0x54ced6'
            white:   '0xffffff'
          dim:
            black:   '0x000000'
            red:     '0x8c3336'
            green:   '0x7a8530'
            yellow:  '0x97822e'
            blue:    '0x506d8f'
            magenta: '0x80638e'
            cyan:    '0x497e7a'
            white:   '0x9a9a9a'
          indexed_colors: []

        visual_bell:
          animation: EaseOutExpo
          duration: 0
          color: '0xffffff'

        background_opacity: 1.0

        mouse_bindings:
          - { mouse: Middle, action: PasteSelection }

        mouse:
          double_click: { threshold: 300 }
          triple_click: { threshold: 300 }
          hide_when_typing: true
          url:
            launcher: ${pkgs.xdg_utils}/bin/xdg-open
            modifiers: Control

        selection:
          semantic_escape_chars: ",│`|:\"' ()[]{}<>"
          save_to_clipboard: false

        dynamic_title: true

        cursor:
          style: Block
          unfocused_hollow: true

        live_config_reload: true

        shell:
          program: ${pkgs.tmux}/bin/tmux

        enable_experimental_conpty_backend: false

        alt_send_esc: true

        key_bindings:
          # (Windows/Linux only)
          - { key: V,        mods: Control|Shift,    action: Paste               }
          - { key: C,        mods: Control|Shift,    action: Copy                }
          - { key: Insert,   mods: Shift,   action: PasteSelection               }
          - { key: Key0,     mods: Control, action: ResetFontSize                }
          - { key: Equals,   mods: Control, action: IncreaseFontSize             }
          - { key: Subtract, mods: Control, action: DecreaseFontSize             }
          # (macOS only)
          #- { key: Key0,     mods: Command, action: ResetFontSize                }
          #- { key: Equals,   mods: Command, action: IncreaseFontSize             }
          #- { key: Minus,    mods: Command, action: DecreaseFontSize             }
          #- { key: K,        mods: Command, action: ClearHistory                 }
          #- { key: K,        mods: Command, chars: "\x0c"                        }
          #- { key: V,        mods: Command, action: Paste                        }
          #- { key: C,        mods: Command, action: Copy                         }
          #- { key: H,        mods: Command, action: Hide                         }
          #- { key: Q,        mods: Command, action: Quit                         }
          #- { key: W,        mods: Command, action: Quit                         }
          - { key: Paste,                   action: Paste                        }
          - { key: Copy,                    action: Copy                         }
          - { key: L,        mods: Control, action: ClearLogNotice               }
          - { key: L,        mods: Control, chars: "\x0c"                        }
          - { key: Home,                    chars: "\x1bOH",   mode: AppCursor   }
          - { key: Home,                    chars: "\x1b[H",   mode: ~AppCursor  }
          - { key: End,                     chars: "\x1bOF",   mode: AppCursor   }
          - { key: End,                     chars: "\x1b[F",   mode: ~AppCursor  }
          - { key: PageUp,   mods: Shift,   chars: "\x1b[5;2~"                   }
          - { key: PageUp,   mods: Control, chars: "\x1b[5;5~"                   }
          - { key: PageUp,                  chars: "\x1b[5~"                     }
          - { key: PageDown, mods: Shift,   chars: "\x1b[6;2~"                   }
          - { key: PageDown, mods: Control, chars: "\x1b[6;5~"                   }
          - { key: PageDown,                chars: "\x1b[6~"                     }
          - { key: Tab,      mods: Shift,   chars: "\x1b[Z"                      }
          - { key: Back,                    chars: "\x7f"                        }
          - { key: Back,     mods: Alt,     chars: "\x1b\x7f"                    }
          - { key: Insert,                  chars: "\x1b[2~"                     }
          - { key: Delete,                  chars: "\x1b[3~"                     }
          - { key: Left,     mods: Shift,   chars: "\x1b[1;2D"                   }
          - { key: Left,     mods: Control, chars: "\x1b[1;5D"                   }
          - { key: Left,     mods: Alt,     chars: "\x1b[1;3D"                   }
          - { key: Left,                    chars: "\x1b[D",   mode: ~AppCursor  }
          - { key: Left,                    chars: "\x1bOD",   mode: AppCursor   }
          - { key: Right,    mods: Shift,   chars: "\x1b[1;2C"                   }
          - { key: Right,    mods: Control, chars: "\x1b[1;5C"                   }
          - { key: Right,    mods: Alt,     chars: "\x1b[1;3C"                   }
          - { key: Right,                   chars: "\x1b[C",   mode: ~AppCursor  }
          - { key: Right,                   chars: "\x1bOC",   mode: AppCursor   }
          - { key: Up,       mods: Shift,   chars: "\x1b[1;2A"                   }
          - { key: Up,       mods: Control, chars: "\x1b[1;5A"                   }
          - { key: Up,       mods: Alt,     chars: "\x1b[1;3A"                   }
          - { key: Up,                      chars: "\x1b[A",   mode: ~AppCursor  }
          - { key: Up,                      chars: "\x1bOA",   mode: AppCursor   }
          - { key: Down,     mods: Shift,   chars: "\x1b[1;2B"                   }
          - { key: Down,     mods: Control, chars: "\x1b[1;5B"                   }
          - { key: Down,     mods: Alt,     chars: "\x1b[1;3B"                   }
          - { key: Down,                    chars: "\x1b[B",   mode: ~AppCursor  }
          - { key: Down,                    chars: "\x1bOB",   mode: AppCursor   }
          - { key: F1,                      chars: "\x1bOP"                      }
          - { key: F2,                      chars: "\x1bOQ"                      }
          - { key: F3,                      chars: "\x1bOR"                      }
          - { key: F4,                      chars: "\x1bOS"                      }
          - { key: F5,                      chars: "\x1b[15~"                    }
          - { key: F6,                      chars: "\x1b[17~"                    }
          - { key: F7,                      chars: "\x1b[18~"                    }
          - { key: F8,                      chars: "\x1b[19~"                    }
          - { key: F9,                      chars: "\x1b[20~"                    }
          - { key: F10,                     chars: "\x1b[21~"                    }
          - { key: F11,                     chars: "\x1b[23~"                    }
          - { key: F12,                     chars: "\x1b[24~"                    }
          - { key: F1,       mods: Shift,   chars: "\x1b[1;2P"                   }
          - { key: F2,       mods: Shift,   chars: "\x1b[1;2Q"                   }
          - { key: F3,       mods: Shift,   chars: "\x1b[1;2R"                   }
          - { key: F4,       mods: Shift,   chars: "\x1b[1;2S"                   }
          - { key: F5,       mods: Shift,   chars: "\x1b[15;2~"                  }
          - { key: F6,       mods: Shift,   chars: "\x1b[17;2~"                  }
          - { key: F7,       mods: Shift,   chars: "\x1b[18;2~"                  }
          - { key: F8,       mods: Shift,   chars: "\x1b[19;2~"                  }
          - { key: F9,       mods: Shift,   chars: "\x1b[20;2~"                  }
          - { key: F10,      mods: Shift,   chars: "\x1b[21;2~"                  }
          - { key: F11,      mods: Shift,   chars: "\x1b[23;2~"                  }
          - { key: F12,      mods: Shift,   chars: "\x1b[24;2~"                  }
          - { key: F1,       mods: Control, chars: "\x1b[1;5P"                   }
          - { key: F2,       mods: Control, chars: "\x1b[1;5Q"                   }
          - { key: F3,       mods: Control, chars: "\x1b[1;5R"                   }
          - { key: F4,       mods: Control, chars: "\x1b[1;5S"                   }
          - { key: F5,       mods: Control, chars: "\x1b[15;5~"                  }
          - { key: F6,       mods: Control, chars: "\x1b[17;5~"                  }
          - { key: F7,       mods: Control, chars: "\x1b[18;5~"                  }
          - { key: F8,       mods: Control, chars: "\x1b[19;5~"                  }
          - { key: F9,       mods: Control, chars: "\x1b[20;5~"                  }
          - { key: F10,      mods: Control, chars: "\x1b[21;5~"                  }
          - { key: F11,      mods: Control, chars: "\x1b[23;5~"                  }
          - { key: F12,      mods: Control, chars: "\x1b[24;5~"                  }
          - { key: F1,       mods: Alt,     chars: "\x1b[1;6P"                   }
          - { key: F2,       mods: Alt,     chars: "\x1b[1;6Q"                   }
          - { key: F3,       mods: Alt,     chars: "\x1b[1;6R"                   }
          - { key: F4,       mods: Alt,     chars: "\x1b[1;6S"                   }
          - { key: F5,       mods: Alt,     chars: "\x1b[15;6~"                  }
          - { key: F6,       mods: Alt,     chars: "\x1b[17;6~"                  }
          - { key: F7,       mods: Alt,     chars: "\x1b[18;6~"                  }
          - { key: F8,       mods: Alt,     chars: "\x1b[19;6~"                  }
          - { key: F9,       mods: Alt,     chars: "\x1b[20;6~"                  }
          - { key: F10,      mods: Alt,     chars: "\x1b[21;6~"                  }
          - { key: F11,      mods: Alt,     chars: "\x1b[23;6~"                  }
          - { key: F12,      mods: Alt,     chars: "\x1b[24;6~"                  }
          - { key: F1,       mods: Super,   chars: "\x1b[1;3P"                   }
          - { key: F2,       mods: Super,   chars: "\x1b[1;3Q"                   }
          - { key: F3,       mods: Super,   chars: "\x1b[1;3R"                   }
          - { key: F4,       mods: Super,   chars: "\x1b[1;3S"                   }
          - { key: F5,       mods: Super,   chars: "\x1b[15;3~"                  }
          - { key: F6,       mods: Super,   chars: "\x1b[17;3~"                  }
          - { key: F7,       mods: Super,   chars: "\x1b[18;3~"                  }
          - { key: F8,       mods: Super,   chars: "\x1b[19;3~"                  }
          - { key: F9,       mods: Super,   chars: "\x1b[20;3~"                  }
          - { key: F10,      mods: Super,   chars: "\x1b[21;3~"                  }
          - { key: F11,      mods: Super,   chars: "\x1b[23;3~"                  }
          - { key: F12,      mods: Super,   chars: "\x1b[24;3~"                  }
          - { key: NumpadEnter,             chars: "\n"                          }
      '';
    };

    configFile.i3status-rust = {
      executable = false;
      target = "${config.xdg.configHome}/i3status-rs/config.toml";
      text = ''
        icons = "awesome"

        [theme]
        name = "slick"

        [[block]]
        block = "sound"

        [[block]]
        block = "backlight"

        [[block]]
        block = "net"
        device = "${config.iwFace}"
        ssid = true
        ip = true
        speed_up = false
        speed_down = false
        interval = 5

        [[block]]
        block = "disk_space"
        path = "/"
        alias = "/"
        info_type = "available"
        unit = "GB"
        interval = 20
        warning = 20.0
        alert = 10.0

        [[block]]
        block = "memory"
        display_type = "memory"
        format_mem = "{Mup}%"

        [[block]]
        block = "battery"
        interval = 10

        [[block]]
        block = "cpu"
        interval = 1

        [[block]]
        block = "temperature"
        collapsed = true
        interval = 5

        [[block]]
        block = "uptime"

        [[block]]
        block = "time"
        interval = 60
        format = "%a %d/%m %R"
      '';
    };
  } else
  {
    enable = true;
  };
}
