{ sources ? import ./nix/sources.nix {}
, home-manager ? import (sources.home-manager + "/home-manager/home-manager.nix")
, pkgs ? import sources.nixpkgs {}
, system ? import ./system { inherit pkgs; }
, home ? import ./home { inherit home-manager pkgs; }
}: pkgs.lib.zipAttrs [ system home ]
