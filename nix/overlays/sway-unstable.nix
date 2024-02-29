final: prev:
{
  wlroots-unstable = (final.wlroots_0_17.overrideAttrs (old: {
    version = "unstable-2024-02-29";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "889150f8660a3e802d377670e57f3951c9266510";
      hash = "sha256-5QrJ7e3xXAetmAOMlOhi5KgbmshDkzuLODSRgSQ8+tc=";
    };
  })).override { };

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "unstable-2024-02-29";
    src = final.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "0b84d82b9aad05010479140774ac5ee1fea8ea97";
      hash = "sha256-kg8OPIDUQDaOqmi8PaKY7n2PcrBCpYn0XfFu3jrrs64=";
    };

    nativeBuildInputs = with final; (old.nativeBuildInputs or [ ]) ++ [ bash-completion fish ];

    # Our version of sway already has this patch upstream, so we filter it out.
    patches = builtins.filter
      (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
      (old.patches or [ ]);

  })).override { wlroots_0_16 = final.wlroots-unstable; };
}
