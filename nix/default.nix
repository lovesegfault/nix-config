let
  sources = import ./sources.nix;
in rec {
  home-manager = import (sources.home-manager + "/nixos");
  lib = import (sources.nixpkgs + "/lib");
  nixos = import (sources.nixpkgs + "/nixos");
  pkgs = import sources.nixpkgs;
  lorri = import sources.lorri;
}
