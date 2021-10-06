{ lib, pkgs, ... }: {
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
    xautolock.extraOptions = [ "-lockaftersleep" ];
  };

  systemd.user.services = {
    xautolock-session.Install.WantedBy = lib.mkForce [ "i3-session.target" ];
    xss-lock.Install.WantedBy = lib.mkForce [ "i3-session.target" ];
  };
}
