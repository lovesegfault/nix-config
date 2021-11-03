{ lib, ... }: {
  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    config = {
      pipewire."context.properties"."default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
        176400
        192000
        358000
        384000
        716000
        768000
      ];
      pipewire-pulse."stream.properties"."resample.quality" = 15;
      client."stream.properties"."resample.quality" = 15;
      client-rt."stream.properties"."resample.quality" = 15;
    };
    media-session.config.bluez-monitor.properties = {
      "bluez5.headset-roles" = [ "hsp_hs" "hsp_ag" ];
      "bluez5.codecs" = [ "aac" "ldac" "aptx_hd" ];
    };
  };

  sound.enable = true;
}
