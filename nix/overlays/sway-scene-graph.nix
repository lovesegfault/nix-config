final: prev:
with final.lib;
{
  libdrm_latest = final.libdrm.overrideAttrs (_: rec {
    version = "2.4.114";
    src = final.fetchurl {
      url = "https://dri.freedesktop.org/libdrm/libdrm-${version}.tar.xz";
      hash = "sha256-MEnPhDpH0S5e7vvDvjSW14L6CfQjRr8Lfe/j0eWY0CY=";
    };
  });

  hwdata_latest = final.hwdata.overrideAttrs (_: rec {
    version = "0.364";
    src = final.fetchFromGitHub {
      owner = "vcrhonek";
      repo = "hwdata";
      rev = "v${version}";
      hash = "sha256-9fGYoyj7vN3j72H+6jv/R0MaWPZ+4UNQhCSWnZRZZS4=";
    };

    outputHash = null;
  });

  wayland-protocols_latest = final.wayland-protocols.overrideAttrs (old: rec {
    inherit (old) pname;
    version = "1.28";
    src = final.fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/${pname}/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
      hash = "sha256-x2Wftr8UkF5o72BfiY3mDRwGa/ZtvqknmFc93ewVNbY=";
    };
  });

  mesa_latest = (final.mesa.overrideAttrs (old: rec {
    version = "22.3.0-rc4";
    src = final.fetchurl {
      url = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-${version}/mesa-mesa-${version}.tar.gz";
      hash = "sha256-EVVY1IrYaktFLR6WKEbz0L/Fbxc+iiceVVnkhYTb7bQ=";
    };
    mesonFlags = remove "-Dxvmc-libs-path=${placeholder "drivers"}/lib" old.mesonFlags;
  })).override { libdrm = final.libdrm_latest; wayland-protocols = final.wayland-protocols_latest; };

  wlroots_0_17 = (final.wlroots_0_15.overrideAttrs (old: {
    version = "unstable-2022-11-25";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "f0375eed24276e27e036f724c9fde5d344fc140a";
      hash = "sha256-41XAMSnkogNcjtLFWQooFHnePV/3OvYwq8AUwk8qMxU=";
    };
    buildInputs = old.buildInputs ++ [ final.hwdata_latest ];
    dontStrip = true;
  })).override { mesa = final.mesa_latest; wayland-protocols = final.wayland-protocols_latest; };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-11-24";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "c05362699e1f29c27678656f243102e0dcd9b80d";
      hash = "sha256-vkpzcpFOJthXhxBIZ++eavO/HoZj7XgmAL/otGzrQtI=";
    };
    buildInputs = old.buildInputs ++ (with final; [ pcre2 xorg.xcbutilwm ]);
    dontStrip = true;
  })).override { wayland-protocols = final.wayland-protocols_latest; wlroots = final.wlroots_0_17; };
}
