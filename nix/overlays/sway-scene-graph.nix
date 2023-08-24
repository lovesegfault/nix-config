final: prev:
{
  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-07-28";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "7bf6c1fc6c824bb2e031d464000ae41c86c459e5";
      hash = "sha256-5aSH5zY7NBXNNftexHWgk4K8ksevKxh3ugITrZEImak=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-07-24";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "e6a87c619b9af8f263720ffd511dbd221a81eb94";
      hash = "sha256-EltpBOr6e9ifr0AiDzzzMGCgWa5rDNmFBUyy4NMjEb8=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots_0_17; };
}
