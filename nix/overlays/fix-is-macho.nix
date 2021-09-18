self: super: {
  nixUnstable = super.nixUnstable.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (self.fetchpatch {
        url = "https://gist.githubusercontent.com/lovesegfault/13f9212cecce14a189ed330c7361a76e/raw/69ce30bbc1bc512c596db897b6ce08e68c96f424/fix-is-macho.patch";
        sha256 = "sha256-xQdhR3/wd/BrVPv6Lx68jqGpu0DFQyMpKTdCjHqASio=";
      })
    ];
  });
}
