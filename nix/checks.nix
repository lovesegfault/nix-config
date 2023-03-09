{ self
, pre-commit-hooks
, ...
}:

system:

with self.pkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource ../.;
      hooks = {
        actionlint.enable = true;
        luacheck.enable = true;
        nixpkgs-fmt.enable = true;
        shellcheck = {
          enable = true;
          types_or = lib.mkForce [ ];
        };
        shfmt.enable = true;
        statix.enable = true;
        stylua.enable = true;
      };
    };
} // (deploy-rs.lib.deployChecks self.deploy)
