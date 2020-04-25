{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  environment = {
    enableDebugInfo = true;
    systemPackages = with pkgs; [ cntr git neovim ];
  };
}
