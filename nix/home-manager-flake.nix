{ nixpkgs, templates, ... }:
{ config, ... }: {
  nix.registry = {
    templates.flake = templates;
    nixpkgs.flake = nixpkgs;
  };

  systemd.user.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.dataHome}/nixpkgs\${NIX_PATH:+:}$NIX_PATH";

  xdg.dataFile."nixpkgs".source = nixpkgs;

  xdg.configFile."nix/nix.conf".text = ''
    flake-registry = ${config.xdg.configHome}/nix/registry.json
  '';
}
