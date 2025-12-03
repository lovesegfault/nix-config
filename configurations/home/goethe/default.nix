# Home-manager configuration for goethe
{ flake, ... }:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # Internal modules via flake outputs
    self.homeModules.default
    self.homeModules.standalone
  ];

  # Home settings
  home = {
    username = "bemeurer";
    homeDirectory = "/home/bemeurer";
    uid = 22314791;
  };
}
