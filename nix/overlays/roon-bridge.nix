self: super: {
  roon-bridge =
    let
      inherit (self.stdenv.targetPlatform) system;
      throwSystem = throw "Unsupported system: ${system}";
    in
    super.roon-bridge.overrideAttrs (_:
      {
        src = {
          x86_64-linux = self.fetchurl {
            url = "https://web.archive.org/web/20210729154257/http://download.roonlabs.com/builds/RoonBridge_linuxx64.tar.bz2";
            sha256 = "sha256-dersaP/8qkl9k81FrgMieB0P4nKmDwjLW5poqKhEn7A=";
          };
          aarch64-linux = self.fetchurl {
            url = "https://web.archive.org/web/20210803071334/http://download.roonlabs.com/builds/RoonBridge_linuxarmv8.tar.bz2";
            sha256 = "sha256-zZj7PkLUYYHo3dngqErv1RqynSXi6/D5VPZWfrppX5U=";
          };
        }.${system} or throwSystem;
      });
}
