{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      realtime-scheduling = "yes";
      default-sample-format = "s32le";
      default-sample-rate = 96000;
      alternate-sample-rate = 88200;
      default-sample-channels = 2;
      default-fragments = 2;
      enable-lfe-remixing = "no";
      default-fragment-size-msec = 125;
      resample-method = "src-sinc-best-quality";
    };
  };

  security.rtkit.enable = true;

  sound.enable = true;
}
