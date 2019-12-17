{ pkgs, ... }: {
  imports = [
    ../modules/aarch64-build-box.nix
    ../modules/documentation.nix
    ../modules/lxd.nix
    ../modules/qemu.nix
    ../modules/stcg-cachix.nix
    ../modules/stcg-cameras.nix
  ];

  environment.systemPackages = with pkgs; [ neovim ];
}
