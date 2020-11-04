self: super: {
  roon-server = super.roon-server.overrideAttrs (_: {
    src = self.fetchurl {
      url = "https://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
      sha256 = "17gzwzh141ga2ywdiin2g5cwzidgcd4a3qjgzcfjkms7xkgz60jl";
    };
  });
}
