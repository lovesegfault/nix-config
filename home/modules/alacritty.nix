{ pkgs, ... }:{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        normal = {
          family = "Hack";
          style = "Regular";
        };
        bold = {
          family = "Hack";
          style = "Bold";
        };
        italic = {
          family = "Hack";
          style = "Italic";
        };
        size = 10;
      };
      colors = {
        primary = {
          background = "0x0A0E14";
          foreground = "0xB3B1AD";
        };
        normal = {
          black = "0x01060E";
          blue = "0x53BDFA";
          cyan = "0x90E1C6";
          green = "0x91B362";
          magenta = "0xFAE994";
          red = "0xEA6C73";
          white = "0xC7C7C7";
          yellow = "0xF9AF4F";
        };
        bright = {
          black = "0x686868";
          blue = "0x59C2FF";
          cyan = "0x95E6CB";
          green = "0xC2D94C";
          magenta = "0xFFEE99";
          red = "0xF07178";
          white = "0xFFFFFF";
          yellow = "0xFFB454";
        };
      };
      mouse.url.modifiers = "Control";
      shell.program = "${pkgs.zsh}/bin/zsh";
      key_bindings = [
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "Insert";
          mods = "Shift";
          action = "PasteSelection";
        }
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Equals";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Add";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Subtract";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Return";
          mods = "Alt";
          action = "ToggleFullscreen";
        }
      ];
    };
  };
}
