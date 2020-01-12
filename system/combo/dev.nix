{ pkgs, ... }: {
  imports =
    [ ../modules/documentation.nix ../modules/lxd.nix ../modules/qemu.nix ];

  environment.systemPackages = with pkgs; [ neovim ];
  services.lorri.enable = true;
}
