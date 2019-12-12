{ pkgs, ... }:{
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/sway.nix
    ../combo/optiplex-3070.nix
  ];

  home.packages = with pkgs; [ chromium ];
}
