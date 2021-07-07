self: super: {
  roon-server = super.roon-server.overrideAttrs (_: rec {
    name = "roon-server-${version}";
    version = "1.8-806";

    src = self.fetchurl {
      url = "https://web.archive.org/web/20210707070319/http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "sha256-TRgsHR71wNz2MoH+RZrIaWEzQSAbo+q8ICKfmmCFy5Y=";
    };
  });
}
