{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    disabledPlugins = [ "sap" ];
    settings = {
      General = {
        FastConnectable = "true";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
      };
    };
  };

  services.blueman.enable = true;

  hardware.pulseaudio = {
    package = pkgs.pulseaudio.override { bluetoothSupport = true; };
    extraConfig = ''
      load-module module-bluetooth-discover
      load-module module-bluetooth-policy
      load-module module-switch-on-connect
    '';
    extraModules = with pkgs; [ pulseaudio-modules-bt ];
  };
}
