# Package definitions
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs) nix-fast-build;
        neovim = pkgs.neovim-bemeurer;
      };
    };
}
