{ self
, pre-commit-hooks
, ...
}:

system:

with self.nixpkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource ../.;
      hooks = {
        nixpkgs-fmt.enable = true;
        nix-linter.enable = true;
        stylua = {
          enable = true;
          types = [ "file" "lua" ];
          entry = "${stylua}/bin/stylua";
        };
        luacheck = {
          enable = true;
          types = [ "file" "lua" ];
          entry = "${luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
        };
        actionlint = {
          enable = true;
          files = "^.github/workflows/";
          types = [ "yaml" ];
          entry =
            let
              actionlintBin = "${actionlint}/bin/actionlint";
              pyflakesBin = "${python3Packages.pyflakes}/bin/pyflakes";
              shellcheckBin = "${shellcheck}/bin/shellcheck";
            in
            "${actionlintBin} -pyflakes ${pyflakesBin} -shellcheck ${shellcheckBin}";
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
