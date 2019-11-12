{ config, pkgs, ... }: {
  xdg.configFile."waybar/config" = {
      source = "${config.home.homeDirectory}/src/nix-config/home/files/waybar.conf";
    };
      xdg.configFile."waybar/style.css" = {
      source = "${config.home.homeDirectory}/src/nix-config/home/files/waybar.style.css";
    };
}
