self: super: {
  wlroots = super.wlroots.overrideAttrs (oldAttrs: {
    version = "unstable-2021-03-11";

    src = self.fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = "44fa2c4b49ced30a69e86a2ed78dd9bf62e0fbb3";
      sha256 = "sha256-F3LHf0xfnqHl6h4zc2EBY41l5ssjMeaEJq9btxDb2mw=";
    };

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ (with self; [
      libuuid
      xorg.xcbutilrenderutil
      xwayland
    ]);
  });

  sway-unwrapped = super.sway-unwrapped.overrideAttrs (oldAttrs: {
    version = "unstable-2021-03-12";

    src = self.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "e5913f81064d4c5b89cdab0cd75d2b5ff5a47c48";
      sha256 = "sha256-CYaGFfex9QI+j6zPn6frBeprwVtpe12O5my6q1051So=";
    };

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ (with self; [
      libdrm
    ]);

    mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
      "-Dsd-bus-provider=libsystemd"
    ];
  });
}
