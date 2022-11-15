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
    version = "unstable-2022-11-15";

    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "265439600e2491a460253bdb59168f139cb08aea";
      hash = "sha256-kmdVoHB5OAXGNq7Hw0dC7ydfw3Uh+LrD+EovPd152mk=";
    };

    buildInputs = old.buildInputs ++ [ final.hwdata_364 ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-11-15";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "89e41cb62edf9377fdfc3980e5f6f8b18d1732aa";
      hash = "sha256-q21sN63OgrJezSb4+dLc9nr6NpQ04K9pQ4v/6THUgwo=";
    };

    buildInputs = old.buildInputs ++ (with final; [ pcre2 xorg.xcbutilwm ]);
  })).override { wlroots = final.wlroots_0_17; };
}
