{ pkgs, ... }: {
  imports = [
    ../modules/documentation.nix
    ../modules/lxd.nix
    ../modules/qemu.nix
    ../modules/stcg-cachix.nix
  ];

  environment.systemPackages = with pkgs; [ neovim ];
}
