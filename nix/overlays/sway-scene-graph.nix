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

  wlroots_0_16 = final.wlroots_0_15.overrideAttrs (old: {
    version = "unstable-2022-11-08";

    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "eec95e3d5e1a4f2e13b1f6b34cc287475ca57daf";
      sha256 = "sha256-be2sn82vNdq7vItsEGILJGMvuQfvAjyZSjpV9CRT91A=";
    };

    buildInputs = old.buildInputs ++ [ final.hwdata_364 ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-11-01";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "5b3d952026515c432329e17152d95e6ac5cb8bf5";
      hash = "sha256-tqrpji/X4P7u8gc5bDgoOsrngi8ZX1hw9efPIXLWZ+w=";
    };

    buildInputs = old.buildInputs ++ (with final; [ pcre2 xorg.xcbutilwm ]);
  })).override { wlroots = final.wlroots_0_16; };
}
