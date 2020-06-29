self: super: {
  python3 = super.python3.override {
    packageOverrides = pySelf: pySuper: {
      mutagen = pySuper.mutagen.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          (self.fetchpatch {
            url = "https://gist.githubusercontent.com/lovesegfault/3b52ed6e996ee4390d5b3096a6de5a54/raw/798c914deced8bcddf387426fde8fa1f2b13b8fb/gistfile1.txt";
            sha256 = "1xylvgqqw4dmvs6ybynxzb4hxbl6ndd38pglvyxml0wq4gkszbbf";
          })
        ];
      });
    };
  };

  python3Packages = self.python3.pkgs;
}
