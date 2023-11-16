final: prev:
{
  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-11-15";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "303f23d7dddd028655b82766c042dcde17cbdebe";
      hash = "sha256-yun4yTcTMBBNEr59cqlpf2icGZ7rrnW3SuA7oo4okVw=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-11-16";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "3b00cee2d2f883d760924e29733bc430195cc5db";
      hash = "sha256-ee0/q604BAxMyZq7thODa7dLdqDLyeNHKz90Vj3SVss=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots_0_17; };
}
