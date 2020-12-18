self: super: {
  roon-server = super.roon-server.overrideAttrs (_: {
    src = self.fetchurl {
      url = "https://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "sha256-S1c3RvN/HE8zwpGZARYRy/Gu4OTG0CjWbxJhZ3cKoVE=";
    };
  });
}
