final: prev: {
  # FIXME: using my patch for now
  #
  # The fork is still 2.1.8, while nixpkgs' expression is now 2.2.0. Two of the
  # attributes that came with the 2.2.0 bump do not apply to this source:
  #   - `sourceRoot+=/nix-output-monitor`, for the monorepo layout upstream
  #     adopted in 2.2.0; this fork is still flat.
  #   - the `doc-tests` test target, which 2.1.8 does not define.
  # Override both via extraComposeFunctions so they compose with the cabal
  # overrides rather than being layered on the built derivation.
  nix-output-monitor = prev.nix-output-monitor.override {
    extraComposeFunctions = [
      (final.haskell.lib.compose.overrideCabal (_: {
        src = final.fetchFromGitHub {
          owner = "lovesegfault";
          repo = "nix-output-monitor";
          rev = "c9ce708f72b95d92f52b77e04d51dd214cc58592";
          hash = "sha256-dTL3f1zx2PNqmemvWhmuwdXdI1F3FcrkHC86F1Y78qQ=";
          postFetch = ''
            rm -f $out/log.json
          '';
        };
        postUnpack = "";
        testTargets = [ "unit-tests" ];
      }))
    ];
  };
}
