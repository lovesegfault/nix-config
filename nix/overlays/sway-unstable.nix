final: prev:
{
  wayland-protocols-unstable = final.wayland-protocols.overrideAttrs (old: rec {
    version = "1.38";
    src = final.fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/${old.pname}/-/releases/${version}/downloads/${old.pname}-${version}.tar.xz";
      hash = "sha256-/xcpLAUVnSsgzmys/kLX4xooGY+hQpp2mwOvfDhYHb4=";
    };
  });

  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-11-11";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "85e2b662f195bb2999cb906d691f4ab8580b20dd";
      hash = "sha256-NL1uCmUB8hN6yFAZc2FU67BSB4WgIw7iPMaMysTHluc=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      final.lcms2
    ];
  })).override { wayland-protocols = final.wayland-protocols-unstable; };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-11-11";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "fdc4318ac66d257d21e8f3b953e341d5e80a1ddc";
      hash = "sha256-uYawl7FhqgQaSsqh20VVwM3FwRfiGAp4lvVvPBz0mMA=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Sway master no longer has an xwayland enable option
    mesonFlags = builtins.filter
      (f: f != "-Dxwayland=enabled")
      (old.mesonFlags or [ ]);
  })).override { wlroots = final.wlroots-unstable; };
}
