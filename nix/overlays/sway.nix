self: super: {
  wlroots = super.wlroots.overrideAttrs (oldAttrs: {
    version = "unstable-2021-03-11";

    src = self.fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = "d9cae04ffc3140408f2604eeff7d4776fe8d9548";
      sha256 = "sha256-JU3pkhjpEdgzyxj8CgsTvA5V1Jiw3VN+jHZ0CoRa98k=";
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
      rev = "1.6-rc2";
      sha256 = "sha256-vAWmHSXJ5nJxfu20CPlTZalNbdn/IBg2SGZdqV+GYDc=";
    };

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ (with self; [
      libdrm
    ]);

    mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
      "-Dsd-bus-provider=libsystemd"
    ];
  });
}
