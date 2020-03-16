{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  services.lorri.enable = true;
  environment = {
    enableDebugInfo = true;
    systemPackages = with pkgs; [ git neovim ];
  };
}
