{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = false;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };
}
