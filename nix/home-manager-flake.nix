{ nixpkgs, ... }@inputs:
{ config, lib, ... }: {
  systemd.user.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.dataHome}/nixpkgs\${NIX_PATH:+:}$NIX_PATH";

  xdg.dataFile."nixpkgs".source = nixpkgs;

  xdg.configFile."nix/nix.conf".text = ''
    flake-registry = ${config.xdg.configHome}/nix/registry.json
  '';

  xdg.configFile."nix/registry.json".text = builtins.toJSON {
    version = 2;
    flakes =
      let
        mkFlakeRef = id: {
          from = { inherit id; type = "indirect"; };
          to = ({
            type = "path";
            path = inputs.${id}.outPath;
          } // lib.filterAttrs
            (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
            inputs.${id});
        };
      in
      [
        (mkFlakeRef "self")
        (mkFlakeRef "nixpkgs")
        (mkFlakeRef "templates")
      ];
  };
}
