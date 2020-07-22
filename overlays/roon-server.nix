self: super: {
  roon-server = super.roon-server.overrideAttrs (oldAttrs: rec {
    version = "100700571";
    src = self.fetchurl {
      url = "http://download.roonlabs.com/updates/stable/RoonServer_linuxx64_${version}.tar.bz2";
      sha256 = "d330287cf77c32f3a4706ff3d12e6f30ea4abfcea29b9b6f98f37a10dca73ba4";
    };
    installPhase = (oldAttrs.installPhase or "") + ''
      ln -s ${self.zlib}/lib/libz.so.1 $out/opt/RoonMono/lib/libz.so.1
    '';
  });
}
