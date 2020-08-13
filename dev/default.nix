{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  environment = {
    enableDebugInfo = true;
    systemPackages = with pkgs; [ git neovim tmate ];
  };

  # nixpkgs.overlays = [ (import ../overlays/arcanist.nix) ];
}
