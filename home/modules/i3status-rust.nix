{ config, pkgs, ... }: {
  xdg.configFile."i3status-rust.toml" = {
    source = ../files/i3status-rust.toml;
  };
}
