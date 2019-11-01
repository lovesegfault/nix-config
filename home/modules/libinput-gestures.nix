{ config, pkgs, ... }: {
  xdg.configFile."libinput-gestures.conf" = {
      source =
        "${config.home.homeDirectory}/src/nix-config/home/files/libinput-gestures.conf";
    };
}
