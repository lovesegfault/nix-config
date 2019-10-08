{ config, pkgs, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME/opt";
      documents = "$HOME/documents";
      download = "$HOME/tmp";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      publishShare = "$HOME/opt";
      templates = "$HOME/opt";
      videos = "$HOME/opt";
    };
    configFile."mako/config" = {
      source = "/home/bemeurer/.config/nixpkgs/files/mako.conf";
    };
    configFile."sway/config" = {
      source = "/home/bemeurer/.config/nixpkgs/files/sway.conf";
    };
    configFile."swaylock/config" = {
      source = "/home/bemeurer/.config/nixpkgs/files/swaylock.conf";
    };
    configFile."i3status-rs.toml" = {
      source = "/home/bemeurer/.config/nixpkgs/files/i3status-rs.toml";
    };
  };
}
