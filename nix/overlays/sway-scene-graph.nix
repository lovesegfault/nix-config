final: prev:
{
  wlroots_0_18 = (final.wlroots_0_16.overrideAttrs (old: {
    version = "unstable-2023-12-21";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "11e3c376e7b843c1bc8ba182260437103db2ca25";
      hash = "sha256-ghgTCbwr/nrZ64Le/0dMbdsuLajaDdxLzj3HJNPGIJg=";
    };
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libdisplay-info
      final.libliftoff
    ];
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2023-12-06";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "2f82cdae5a8d2c0204b06855cccf7f470a587cea";
      hash = "sha256-XqJrU6osJRwQqogWQWPO2XERHCUh5DjnJdd6DHV/T4A=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots_0_18; };
}
