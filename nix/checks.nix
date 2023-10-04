{ self
, pre-commit-hooks
, ...
}:

system:

with self.pkgs.${system};

{
  parse = stdenvNoCC.mkDerivation {
    name = "check-parse-nix";
    src = lib.cleanSource self;
    nativeBuildInputs = [ nix ];
    dontPatch = true;
    dontConfigure = true;
    dontFixup = true;
    buildPhase = ''
      nix-instantiate --json --parse "$src"/**/*.nix
    '';
    installPhase = ''
      touch "$out"
    '';
  };
  pre-commit-check = pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource self;
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
}
