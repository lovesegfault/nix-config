{ self
, pre-commit-hooks
, ...
}:

system:

with self.nixpkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = gitignoreSource ../.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
      stylua = {
        enable = true;
        name = "stylua";
        entry = "${stylua}/bin/stylua";
        types = [ "file" "lua" ];
      };
      luacheck = {
        enable = true;
        name = "luacheck";
        entry = "${luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
        types = [ "file" "lua" ];
      };
    };
    settings.nix-linter.checks = [
      "DIYInherit"
      "EmptyInherit"
      "EmptyLet"
      "EtaReduce"
      "FreeLetInFunc"
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
      "no-AlphabeticalArgs"
      "no-AlphabeticalBindings"
    ];
  };
} // (deploy-rs.lib.deployChecks self.deploy)
