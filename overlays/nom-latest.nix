final: prev: {
  # FIXME: using my patch for now
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (_: {
    src = final.fetchFromGitHub {
      owner = "lovesegfault";
      repo = "nix-output-monitor";
      rev = "c9ce708f72b95d92f52b77e04d51dd214cc58592";
      hash = "sha256-dTL3f1zx2PNqmemvWhmuwdXdI1F3FcrkHC86F1Y78qQ=";
      postFetch = ''
        rm -f $out/log.json
      '';
    };
  });
}
