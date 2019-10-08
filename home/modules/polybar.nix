{ config, pkgs, ... }: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      nlSupport = false;
      iwSupport = true;
      mpdSupport = true;
      githubSupport = true;
    };
    config = {
      "bar/top" = {
        monitor = "\${env:MONITOR:eDP-1}";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-center = "date";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
    };
    script = "polybar bar &";
  };
}
