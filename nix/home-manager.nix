let
  sources = import ./sources.nix {};
in import (sources.home-manager + "/nixos")
