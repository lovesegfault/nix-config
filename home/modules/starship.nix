{ config, pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml" = { source = ../files/starship.toml; };
}
