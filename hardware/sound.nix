{ lib, pkgs, ... }: {
  environment.etc = {
    "pipewire/pipewire.conf.d/99-allowed-rates.conf".text = builtins.toJSON {
      "context.properties"."default.clock.allowed-rates" = [
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
    "pipewire/pipewire-pulse.conf.d/99-resample.conf".text = builtins.toJSON {
      "stream.properties"."resample.quality" = 15;
    };
    "pipewire/client.conf.d/99-resample.conf".text = builtins.toJSON {
      "stream.properties"."resample.quality" = 15;
    };
    "pipewire/client-rt.conf.d/99-resample.conf".text = builtins.toJSON {
      "stream.properties"."resample.quality" = 15;
    };
  };

  environment.systemPackages = with pkgs; [ pulseaudio ];

  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  sound.enable = true;
}
