let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) nixpkgs;
  gitignoreSource = (import sources.gitignore { lib = import (nixpkgs + "/lib"); }).gitignoreSource;
  home-manager = import (sources.home-manager + "/nixos");
  impermanence-home = sources.impermanence + "/home-manager.nix";
  impermanence-nixos = sources.impermanence + "/nixos.nix";
  nix-pre-commit-hooks = (import (sources.nix-pre-commit-hooks + "/nix") { }).packages;
  nixus = import sources.nixus { };
  sops-nix = import sources.sops-nix;
  sops-nixos = import (sources.sops-nix + "/modules/sops");
}
