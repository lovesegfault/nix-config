{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = false;
    config = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
}
