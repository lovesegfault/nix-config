{ pkgs, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "32x32";
    };
    settings = {
      global = {
        follow = "keyboard";
        font = "Hack 10";
        format = ''<b>%s</b>\n%b'';
        frame_color = "#53BDFA";
        geometry = "500x100-5+5";
        horizontal_padding = 5;
        line_height = 4;
        padding = 5;
        transparency = 100;
      };
      urgency_normal = {
        background = "#0A0E14";
        foreground = "#B3B1AD";
      };
    };
  };
}
