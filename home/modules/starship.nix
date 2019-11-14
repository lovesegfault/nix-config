{ config, pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml" = {
    source =
      "${config.home.homeDirectory}/src/nix-config/home/files/starship.toml";
  };
}
