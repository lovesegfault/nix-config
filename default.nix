{ nixpkgs ? import <nixpkgs> {}
, lib ? import (nixpkgs.path + "/lib")
, system ? import ./system { pkgs = nixpkgs; }
, home ? import ./home { pkgs = nixpkgs; }
}: lib.zipAttrs [ system home ]
