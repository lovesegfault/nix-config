self: super: {
  roon-server = super.roon-server.overrideAttrs (oldAttrs: {
    src = self.fetchurl {
      url = "https://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "0vrdcf6nbybmxfgmqyc3wn2kj3cz9x5frcysp5f5z2r0p6ksx5mj";
    };
  });
}
