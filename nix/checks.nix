{ self
, pre-commit-hooks
, ...
}:

system:

with self.pkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource self;
      hooks = {
        actionlint.enable = true;
        luacheck.enable = true;
        nil.enable = true;
        nixpkgs-fmt.enable = true;
        shellcheck = {
          enable = true;
          types_or = lib.mkForce [ ];
        };
        shfmt.enable = true;
        statix.enable = true;
        stylua.enable = true;

        nix-parse = {
          enable = true;
          name = "nix-parse";
          description = "Parses all Nix files";
          entry = "${nix}/bin/nix-instantiate --readonly-mode --store dummy:// --json --parse";
          files = "\\.nix$";
        };
      };
    };
}
