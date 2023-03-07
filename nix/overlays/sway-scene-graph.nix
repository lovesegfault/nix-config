final: prev:
with final.lib;
{
  libdisplay-info = prev.libdisplay-info.overrideAttrs (old: rec {
    version = "0.1.1";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = old.pname;
      rev = version;
      hash = "sha256-7t1CoLus3rPba9paapM7+H3qpdsw7FlzJsSHFwM/2Lk=";
    };
  });

  wlroots_0_17 = final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-02-15";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "774d2c82f0cc6ed5b20762fb74bab3e8bfd9f858";
      hash = "sha256-XIH/eTL1A42spHAvbeELAEXJoVdJEdBUvYTL/Z98m80=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [ final.libdisplay-info ];
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwerror=false" ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-02-15";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "71cf46491af766dc98a0d4082d7a0c22e3980632";
      hash = "sha256-hi5kruKcBHFkluzsafrypu/d5x4n7SAJd8NwtVbAiu4=";
    };
  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
