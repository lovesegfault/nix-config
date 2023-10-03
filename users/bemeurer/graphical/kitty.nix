{ lib, hostType, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 5000;
      scrollback_pager_history_size = 32768;
      strip_trailing_spaces = "smart";
      repaint_delay = 16; # ~60Hz
      enable_audio_bell = false;
      update_check_interval = 0;
    } // (lib.optionalAttrs (hostType == "darwin")) {
      macos_show_window_title_in = "window";
      macos_colorspace = "default";
    };

    darwinLaunchOptions = [ "--single-instance" "--directory=~" ];
  };
}
