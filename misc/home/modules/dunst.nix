{ pkgs, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "hicolor";
      package = pkgs.hicolor-icon-theme;
      size = "32x32";
    };
    settings = {
      urgency_low = {
        background = "#282c34";
        foreground = "#abb2bf";
        timeout = 10;
      };
      urgency_normal = {
        background = "#282c34";
        foreground = "#abb2bf";
        timeout = 20;
      };
      urgency_critical = {
        background = "#1b182c";
        foreground = "#ff8080";
        frame_color = "#000000";
        timeout = 0;
      };
    };
  };
}
