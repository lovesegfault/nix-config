self: super: {
  plater = super.plater.overrideAttrs (_: rec {
    NIX_CFLAGS_COMPILE = "-O3 -march=skylake -flto=12 -fgraphite-identity -floop-nest-optimize -fipa-pta -fno-semantic-interposition -fno-math-errno -fno-trapping-math -fdevirtualize-at-ltrans -fno-plt";
    NIX_CFLAGS_LINK = "${NIX_CFLAGS_COMPILE} -fuse-ld=gold";
    cmakeFlags = [ "-DCMAKE_AR=${self.gcc-unwrapped}/bin/gcc-ar" "-DCMAKE_RANLIB=${self.gcc-unwrapped}/bin/gcc-ranlib" ];

    meta.platforms = [ "x86_64-linux" ];
  });
}
