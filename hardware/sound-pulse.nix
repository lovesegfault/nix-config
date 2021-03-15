{ config, pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    daemon.config = {
      alternate-sample-rate = 176400;
      avoid-resampling = "yes";
      default-fragment-size-msec = 125;
      default-fragments = 2;
      default-sample-channels = 2;
      default-sample-format = "float32le";
      default-sample-rate = 192000;
      enable-lfe-remixing = "no";
      high-priority = "yes";
      nice-level = -20;
      realtime-priority = 5;
      realtime-scheduling = "yes";
      resample-method = "soxr-vhq";
      rlimit-rtprio = 5;
    };
    configFile = pkgs.runCommand "default.pa" { } ''
      cp ${config.hardware.pulseaudio.package}/etc/pulse/default.pa $out
      # esound creates garbage in $HOME
      sed -i "/load-module module-esound/d" $out
      # we load these manually in hardware/bluetooth.nix
      sed -i "/load-module module-bluetooth/d" $out

      sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/" $out
    '';
    zeroconf.discovery.enable = false;
    zeroconf.publish.enable = false;
  };

  security.rtkit.enable = true;

  sound.enable = true;
}
