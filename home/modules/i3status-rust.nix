{ config, pkgs, ... }: {
  xdg.configFile."i3status-rust.toml" = {
    source =
      "${config.home.homeDirectory}/src/nix-config/home/files/i3status-rust.toml";
  };
}
