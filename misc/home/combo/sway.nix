{ pkgs, ... }: {
  imports = [
    ../modules/mako.nix
    ../modules/sway.nix
    ../modules/swaylock.nix
    ../modules/waybar.nix

    ../pkgs/emojimenu.nix
    ../pkgs/otpmenu.nix
    ../pkgs/passmenu.nix
    ../pkgs/prtsc.nix
    ../pkgs/swaymenu.nix
  ];

  home.packages = with pkgs; [
    grim
    imv
    slurp
  ];
}
