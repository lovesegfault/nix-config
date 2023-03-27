final: prev:
{
  wlroots_0_17 = final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-03-26";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "59d2743c0cc4bb77527449fccfe1fba03357457c";
      hash = "sha256-yivhyQeWLTwHxUISio2P8u0S9Vkp5Lhc7UlNONA1DaQ=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwerror=false" ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-03-03";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "71cf46491af766dc98a0d4082d7a0c22e3980632";
      hash = "sha256-hi5kruKcBHFkluzsafrypu/d5x4n7SAJd8NwtVbAiu4=";
    };
  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
