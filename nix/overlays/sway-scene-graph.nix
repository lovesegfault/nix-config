final: prev:
with final.lib;
{
  mesa_latest = final.mesa.overrideAttrs (old: rec {
    version = "22.3.2";
    src = final.fetchurl {
      url = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-${version}/mesa-mesa-${version}.tar.gz";
      hash = "sha256-uG14v6C/2HeAhyAtynncfHee/plsNnRShN2tIvofg0M=";
    };
    mesonFlags = remove "-Dxvmc-libs-path=${placeholder "drivers"}/lib" old.mesonFlags;
  });

  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-02-04";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "e0b2bf2a6b8699ac75973702a791efe5af8d421e";
      hash = "sha256-CtdYMeWXsCblM+HenD7AP2oqKd+gi+7MoTKANccOPHI=";
    };
  })).override { mesa = final.mesa_latest; };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-12-09";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "993deff56993dd5565061a73b6ca2d65cfa6e135";
      hash = "sha256-6bN3ux/POQwMeNkN8r/sgg+3p6agbgK+1FKzK9oCxiA=";
    };
  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
