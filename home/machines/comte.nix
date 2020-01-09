{ pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/i3.nix

    ../hardware/optiplex-3070.nix
  ];

  home.packages = with pkgs; [ chromium ];
}
