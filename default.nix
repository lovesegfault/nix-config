{ lib ? import <nixpkgs/lib>, system ? import ./system, home ? import ./home }:
lib.zipAttrs [ system home ]
