let
  sources = import ./sources.nix;
in
rec {
  home-manager = import (sources.home-manager + "/nixos");
  lib = import (sources.nixpkgs + "/lib");
  pkgs = import sources.nixpkgs;
}
