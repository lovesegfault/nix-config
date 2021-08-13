self: super: {
  tabnine = self.callPackage
    (
      { stdenv, lib, fetchurl, unzip }:
      let
        system =
          if stdenv.hostPlatform.system == "x86_64-linux" then {
            name = "x86_64-unknown-linux-musl";
            sha256 = "sha256-pttjlx7WWE3nog9L1APp8HN+a4ShhlBj5irHOaPgqHw=";
          } else if stdenv.hostPlatform.system == "x86_64-darwin" then {
            name = "x86_64-apple-darwin";
            sha256 = "sha256-Vxmhl4/bhRDeByGgkdSF8yEY5wI23WzT2iH1OFkEpck=";
          } else throw "Not supported on ${stdenv.hostPlatform.system}";
      in
      stdenv.mkDerivation rec {
        pname = "tabnine";
        # You can check the latest version with `curl -sS https://update.tabnine.com/bundles/version`
        version = "3.5.37";

        src = fetchurl {
          url = "https://update.tabnine.com/bundles/${version}/${system.name}/TabNine.zip";
          inherit (system) sha256;
        };

        dontBuild = true;

        # Work around the "unpacker appears to have produced no directories"
        # case that happens when the archive doesn't have a subdirectory.
        setSourceRoot = "sourceRoot=`pwd`";

        nativeBuildInputs = [ unzip ];

        installPhase = ''
          runHook preInstall
          install -Dm755 TabNine $out/bin/TabNine
          install -Dm755 TabNine-deep-cloud $out/bin/TabNine-deep-cloud
          install -Dm755 TabNine-deep-local $out/bin/TabNine-deep-local
          install -Dm755 WD-TabNine $out/bin/WD-TabNine
          runHook postInstall
        '';

        passthru.platform = system.name;

        meta = with lib; {
          homepage = "https://tabnine.com";
          description = "Smart Compose for code that uses deep learning to help you write code faster";
          license = licenses.unfree;
          platforms = [ "x86_64-darwin" "x86_64-linux" ];
          maintainers = with maintainers; [ lovesegfault ];
        };
      }
    )
    { };

  vimPlugins = super.vimPlugins.extend (_: lsuper: {
    compe-tabnine = lsuper.compe-tabnine.overrideAttrs (_: {
      postFixup = ''
        mkdir -p $target/binaries/${self.tabnine.version}
        ln -s ${self.tabnine}/bin/ $target/binaries/${self.tabnine.version}/${self.tabnine.passthru.platform}
      '';
    });
  });

  lua51Packages = super.lua51Packages.extend (_: lsuper: {
    plenary-nvim = lsuper.plenary-nvim.overrideAttrs (_: {
      knownRockspec = (self.fetchurl {
        url = "https://raw.githubusercontent.com/nvim-lua/plenary.nvim/master/plenary.nvim-scm-1.rockspec";
        sha256 = "08kv1s66zhl9amzy9gx3101854ig992kl1gzzr51sx3szr43bx3x";
      });
    });
  });
}
