final: prev:
{
  wlroots_0_18 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-11-21";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "dbe7fb70273ed1c9008bb5d36546d0d187f1217c";
      hash = "sha256-ZlJyy3+YeOCD0G1uBif7dvewTmm6oznPNtuRFF6YaXk=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-11-19";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "dd1766e823ad70be1a99eee4094ff51424ce22d3";
      hash = "sha256-uR8321YM1lpdBqMsoQOJxOZ3WDq9NreJxDAJOMDV4Y0=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots_0_18; };
}
