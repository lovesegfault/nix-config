{ config, lib, ... }:
{
  environment.systemPackages = [ config.services.pipewire.package ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

    extraConfig = {
      client."99-resample"."stream.properties"."resample.quality" = 15;
      pipewire-pulse."99-resample"."stream.properties"."resample.quality" = 15;
      pipewire."99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
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
    };
  };
}
