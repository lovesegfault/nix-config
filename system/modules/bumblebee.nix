{ config, pkgs, ... }: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ nvidia_x11 ];

  hardware = {
    bumblebee = {
      enable = true;
      connectDisplay = false;
      driver = "nvidia";
    };
    nvidia.modesetting.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: rec {
    bumblebee = pkgs.bumblebee.override {
      extraNvidiaDeviceOptions = ''
        EndSection # close option section

        Section "Screen"
          Identifier "Default Screen"
          Device "DiscreteNvidia"

          # our section is closed later
      '';
    };
  };

  services.xserver.videoDrivers = [ "intel" "nvidia" ];
}
