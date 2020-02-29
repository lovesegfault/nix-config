{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Disable = "Headset";
        Autoconnect = true;
        MultiProfile = "multiple";
      };
    };
  };

  hardware.pulseaudio = {
    package = pkgs.pulseaudio.override { bluetoothSupport = true; };
    extraConfig = ''
      load-module module-switch-on-connect
      load-module module-bluetooth-discover a2dp_config="ldac_eqmid=hq ldac_fmt=f32"
      load-module module-bluetooth-policy
    '';
    extraModules = with pkgs; [ pulseaudio-modules-bt ];
  };
}
