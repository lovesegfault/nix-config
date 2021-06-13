self: super: {
  roon-server = super.roon-server.overrideAttrs (_: rec {
    pname = "roon-server";
    version = "1.8-795";
    name = "${pname}-${version}";

    src = self.fetchurl {
      url = "https://web.archive.org/web/20210610060249/http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "sha256-gC+UquDMyDpgCEYKPp2RRIkHD/4itJssl0hcSEQO5Rc=";
    };
  });
}
