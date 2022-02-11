final: prev: {
  commitizen = prev.commitizen.override {
    argcomplete = final.python3Packages.argcomplete.overrideAttrs (old: rec {
      version = "1.12.3";
      src = final.python3Packages.fetchPypi {
        inherit (old) pname;
        inherit version;
        sha256 = "sha256-LH2//YwEXqU0kh5jsL5v5l6IWZmQ2NxAisjFQrcqVEU=";
      };
    });
  };
}
