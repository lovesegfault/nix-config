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
    version = "unstable-2023-02-04";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "5007e713b4c0d0f0cd8e97503294b81a250d3459";
      hash = "sha256-OgdGCBLI0YWr4PSXgQhTXEVNcMutLm+Mr7i57q7iH+0=";
    };
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-12-09";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "c77e6c0008747f1de4dee7912009bcba043cb257";
      hash = "sha256-W99yp35sFiS/WwGHn8kmPYS+B/6ldYVMOrF1mq6L+Cs=";
    };
  })).override { libxkbcommon = final.libxkbcommon_1_5_0; wlroots_0_16 = final.wlroots_0_17; };
}
