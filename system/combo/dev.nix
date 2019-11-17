{ pkgs, ... }: {
  imports = [
    ../modules/documentation.nix
    ../modules/lxd.nix
    ../modules/stcg_cachix.nix
  ];

  environment.systemPackages = with pkgs; [ neovim ];
}
