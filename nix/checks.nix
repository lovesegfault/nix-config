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
        nix-linter.enable = true;
        nixpkgs-fmt.enable = true;
        statix.enable = true;
        stylua.enable = true;
      };
      settings.nix-linter.checks = [
        "DIYInherit"
        "EmptyInherit"
        "EmptyLet"
        "EtaReduce"
        "LetInInheritRecset"
        "ListLiteralConcat"
        "NegateAtom"
        "SequentialLet"
        "SetLiteralUpdate"
        "UnfortunateArgName"
        "UnneededRec"
        "UnusedArg"
        "UnusedLetBind"
        "UpdateEmptySet"
        "BetaReduction"
        "EmptyVariadicParamSet"
        "UnneededAntiquote"
        "no-FreeLetInFunc"
        "no-AlphabeticalArgs"
        "no-AlphabeticalBindings"
      ];
    };
} // (deploy-rs.lib.deployChecks self.deploy)
