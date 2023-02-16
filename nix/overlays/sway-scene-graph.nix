final: prev:
with final.lib;
{
  libxkbcommon_1_5_0 = final.libxkbcommon.overrideAttrs (old: rec {
    version = "1.5.0";
    src = final.fetchFromGitHub {
      owner = "xkbcommon";
      repo = "libxkbcommon";
      rev = "xkbcommon-${version}";
      hash = "sha256-+LJa+v4eV36xBNYFDelgLIc7EyHVtspIRAluf16i774=";
    };
  });

  wlroots_0_17 = final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-02-15";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "822eb07eaca392d9b7a99b0d8b96e402c8976fb4";
      hash = "sha256-ntJlF0PXguPsWCOJ7WQYcOKVpESlFaWDapdDGRybVyM=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwerror=false" ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-02-15";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "d767e1a92cba244fdf971641835e73665a9436a3";
      hash = "sha256-LzeS7BcsceFQj0Sfbqi/MzjH9hrAyq1b5rSzo8xzbM8=";
    };
  })).override { libxkbcommon = final.libxkbcommon_1_5_0; wlroots_0_16 = final.wlroots_0_17; };
}
