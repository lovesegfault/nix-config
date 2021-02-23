self: super: {
  roon-server = super.roon-server.overrideAttrs (_: {
    src = self.fetchurl {
      url = "https://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "sha256-YvQLG6DKXQs97GtC/szQ7fTOwOvwk1svJe6mEXTO8ns=";
    };
  });
}
