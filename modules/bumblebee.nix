{ config, pkgs, ... }: {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      bbswitch
      nvidia_x11
    ];
    kernelModules = [ "bbswitch" ];
  };

  hardware = {
    bumblebee = {
      enable = true;
      connectDisplay = false;
      driver = "nvidia";
      group = "video";
      pmMethod = "bbswitch";
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

  services.xserver = {
    libinput.enable = true;
    modules = with pkgs.xorg; [ xf86inputlibinput xf86inputmouse ];
    videoDrivers = [ "modesetting" "intel" "nvidia" ];
  };
}
