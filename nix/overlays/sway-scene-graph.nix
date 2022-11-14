final: prev: {
  hwdata_364 = final.hwdata.overrideAttrs (_: rec {
    version = "0.364";

    src = final.fetchFromGitHub {
      owner = "vcrhonek";
      repo = "hwdata";
      rev = "v${version}";
      hash = "sha256-9fGYoyj7vN3j72H+6jv/R0MaWPZ+4UNQhCSWnZRZZS4=";
    };

    outputHash = null;
  });

  wlroots_0_17 = final.wlroots_0_15.overrideAttrs (old: {
    version = "unstable-2022-11-11";

    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "65836ce357e4140d4e5250228a05ddd96119a883";
      hash = "sha256-QimttzdrgUnE5ewBednTD3O3tTHlD5VL5uL8czAY9fE=";
    };

    buildInputs = old.buildInputs ++ [ final.hwdata_364 ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-11-11";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "2e4007d6048856f6581e4f571e2a36cd42057795";
      hash = "sha256-Q7rzLRz/lGvo5a/eqJoUGE2LSubxuKoVvf8OGlGoeqM=";
    };

    buildInputs = old.buildInputs ++ (with final; [ pcre2 xorg.xcbutilwm ]);
  })).override { wlroots = final.wlroots_0_17; };
}
