{
  hardware.pulseaudio = {
    enable = true;
    daemon.config = {
      avoid-resampling = "yes";
      alternate-sample-rate = 88200;
      default-fragment-size-msec = 125;
      default-fragments = 2;
      default-sample-channels = 2;
      default-sample-format = "s32le";
      default-sample-rate = 96000;
      enable-lfe-remixing = "no";
      realtime-scheduling = "yes";
      resample-method = "speex-float-10";
    };
    extraConfig = ''
      unload-module module-esound-protocol-unix
    '';
  };

  security.rtkit.enable = true;

  sound.enable = true;
}
