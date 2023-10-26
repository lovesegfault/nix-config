final: prev:
{
  wlroots_0_17 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-10-25";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "ffa8e3ec81c093b809c5902e082826120a09429e";
      hash = "sha256-hbqKTtP0bSCw6N/kN/c3QlQzwR42q6tG4K3XMfkf5C4=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-10-25";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "06efc587beb95db72f091a911c3b80746af9cee6";
      hash = "sha256-jR+E45zsyfjvIaSmj33+3Fr9daSFCznZ71ASz6fM7io=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots_0_17; };
}
