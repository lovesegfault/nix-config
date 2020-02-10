{ pkgs, ... }: {
  imports = [ ../modules/documentation.nix ../modules/qemu.nix ];

  environment.systemPackages = with pkgs; [ git neovim ];
  services.lorri.enable = true;
  virtualisation.docker.enable = true;
}
