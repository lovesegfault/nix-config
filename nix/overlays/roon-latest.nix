final: prev: {
  roon-server = prev.roon-server.overrideAttrs (old: {
    version = "2.47.1510";
    src = final.fetchurl {
      url = "https://download.roonlabs.com/updates/production/RoonServer_linuxx64_204701510.tar.bz2";
      hash = "sha256-xuXQLniV2PKIeupfCH00j0e9mRxLocEraENqIUkdWNo=";
    };
  });
}
