{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  environment.systemPackages = with pkgs; [ git neovim ];
  services.lorri.enable = true;
}
