{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    daemon.config = { realtime-scheduling = "yes"; };
  };

  security.rtkit.enable = true;

  sound.enable = true;
}
