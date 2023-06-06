final: prev: {
  tlp = prev.tlp.overrideAttrs (old: {
    version = "unstable-2023-05-04";
    src = final.fetchFromGitHub {
      owner = "lovesegfault";
      repo = "TLP";
      rev = "0f88ac0d407e0701414f821f763dc280f9258d2c";
      hash = "sha256-KHvOmcpDjtMh/BAL98b/ME3jucjJDW2MlHShxrx5PO0=";
    };

    # already applied in my fork
    patches = [ ];
  });
}
