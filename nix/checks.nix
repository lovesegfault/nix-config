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
      nix-parse = {
        enable = true;
        entry = "nix-instantiate --json --parse";
        types = [ "file" "nix" ];
      };
      stylua = {
        enable = true;
        entry = "${stylua}/bin/stylua";
        types = [ "file" "lua" ];
      };
      luacheck = {
        enable = true;
        entry = "${luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
        types = [ "file" "lua" ];
      };
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
