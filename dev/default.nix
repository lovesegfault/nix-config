{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  environment = {
    enableDebugInfo = true;
    systemPackages = with pkgs; [ git neovim ];
  };

  nixpkgs.overlays = [ (import ../overlays/arcanist.nix) ];
}
