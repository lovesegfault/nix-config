{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.nix-config.graphical;
in
with lib;
{
  options.nix-config.graphical = {
    enable = mkEnableOption "graphical nix-config options";
    fonts = {
      enable = mkOption {
        description = "Whether to enable aspell configuration.";
        type = types.bool;
        default = true;
        example = false;
      };
      packages = mkOption {
        description = "Which packages to include fonts from";
        type = types.listOf types.package;
        default = with pkgs; [
          dejavu_fonts
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-extra
          unifont
        ];
        example = [ pkgs.dejavu_fonts ];
      };
    };
  };

  config = mkIf (cfg.enable && (inputs ? stylix)) {
    stylix.fonts = {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
