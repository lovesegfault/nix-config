{ pkgs, ... }: {
  imports = [
    ./mako.nix
    ./sway.nix
    ./swaylock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grim
    imv
    slurp
  ];
}
