  # beets = super.beets.overrideAttrs (
  #   old: {
  #     version = "2020-06-27";
  #     src = super.fetchFromGitHub {
  #       owner = "beetbox";
  #       repo = "beets";
  #       rev = "533cc88df21dc0f4e3041a0dfd2eb2a82af9c4ed";
  #       sha256 = "0q85kgy987xqmcvcxwq4klnc57ddl4lb3gbj303za7mw6k9y9zpw";
  #     };
  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [
  #       self.python3Packages.confuse
  #       self.python3Packages.mediafile
  #     ];
  #     patches = [];
  #   }
  # );
self: super: rec {
  beets = self.callPackage ./beets.nix { pythonPackages = self.python3Packages; };

  python3 = super.python3.override {
    packageOverrides = self: super: {
      confuse = super.callPackage ./confuse.nix { };
      mediafile = super.callPackage ./mediafile.nix { };
    };
  };

  python3Packages = python3.pkgs;
}
