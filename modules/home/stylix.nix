{ pkgs, flake, ... }:
{
  imports = [ flake.inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = "${flake.inputs.tinted-schemes}/base16/ayu-dark.yaml";
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
    targets = {
      # For home-manager-only, most targets won't apply
      gnome.enable = false;
      gtk.enable = false;
      kde.enable = false;
      xfce.enable = false;
    };
  };
}
