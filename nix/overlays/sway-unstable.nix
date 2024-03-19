final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-03-18";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "873e8e455892fbd6e85a8accd7e689e8e1a9c776";
      hash = "sha256-5zX0ILonBFwAmx7NZYX9TgixDLt3wBVfgx6M24zcxMY=";
    };
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-03-18";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "5a7477cb8f568ce4aeb852215ad40899f18f3d91";
      hash = "sha256-56CRUjaebyERr1JGTQFWnrET04gFg9p20GZcixgWoVY=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots = final.wlroots-unstable; };
}
