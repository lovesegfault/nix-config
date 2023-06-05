final: prev:
{
  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-06-03";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "b61d5922f1d0910a848deb100570ad8587aea38d";
      hash = "sha256-yxq/U9zL1ssFZtgT27A96UKteCiKb3zSmbA/dokK76U=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-04-16";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "58df2d60a23cd093edb9800531f52be6b7ba3209";
      hash = "sha256-Wbqi2KOuKVsSGEahYwBMzW4EjLYuC/zJTzBw0xNvKcQ=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots_0_17; };
}
