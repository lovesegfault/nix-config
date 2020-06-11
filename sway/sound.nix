{
  hardware.pulseaudio = {
    enable = true;
    daemon.config = {
      avoid-resampling = "yes";
      default-fragment-size-msec = 125;
      default-fragments = 2;
      default-sample-channels = 2;
      default-sample-format = "s32le";
      default-sample-rate = 48000;
      enable-lfe-remixing = "no";
      high-priority = "yes";
      nice-level = -20;
      realtime-priority = 5;
      realtime-scheduling = "yes";
      resample-method = "speex-float-10";
      rlimit-rtprio = 5;
    };
    extraConfig = ''
      unload-module module-esound-protocol-unix
      load-module module-udev-detect tsched=0
    '';
    zeroconf.discovery.enable = false;
    zeroconf.publish.enable = false;
  };

  security.rtkit.enable = true;

  sound = {
    enable = true;
    extraConfig = ''
      options snd-hda-intel model=generic
    '';
  };
}
