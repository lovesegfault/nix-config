final: prev:
{
  wayland_1_22 = final.wayland.overrideAttrs (old: rec {
    version = "1.22.0";

    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wayland";
      repo = "wayland";
      rev = version;
      hash = "sha256-Y1ePN+FVOigDsnPBnDKkhYnQrm+Obwf/YcCKr/clErw=";
    };
  });

  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-04-16";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "eac2eaa6a97872d0eaab3b7725528d1ad65c80e2";
      hash = "sha256-xwjColWIWQGhywPTUcii8Syvk99bnAf+2f6+ti8369Y=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
    mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwerror=false" ];
  })).override { wayland = final.wayland_1_22; };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-04-16";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "3b3a500ed71be9bf6b2b252b24920d1d02c9ee36";
      hash = "sha256-vV+z5BqHyCWlsA4q4d1g/UPuURGmUMFg36LXbJTLORU=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];
  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
