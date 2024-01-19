final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-01-18";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "0b090c83fb5b5c5741d9a9566a499eabbe079f38";
      hash = "sha256-AlIFB2MN2Du1lbtxHnXYSyaSKt+dbGHBxcW6Xqmv/z8=";
    };
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-01-19";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "ae33f4eb37a8ee647907e4fef72c6a488b8b1138";
      hash = "sha256-ruv97ibSiJyDnjzBOqqXKZkGymzjmaPpM62Pu5VYqEk=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots-unstable; };
}
