{ config, pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = "true";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
      };
    };
  };

  # XXX: Due to how .serviceConfig is an option and .ExecStart is technically
  # a list, you will add multiple ExecStart='s to the .service file, and this
  # not a nixos option, you cant use things like mkForce on it. If you set it to
  # one. The empty one is a signal to systemd, to ignore the original copy
  # will cause it to have 3 entries, the original, an empty, and the new
  systemd.services.bluetooth.serviceConfig.ExecStart =
    [ "" "${config.hardware.bluetooth.package}/libexec/bluetooth/bluetoothd --noplugin=sap" ];

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
