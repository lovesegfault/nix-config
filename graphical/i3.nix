{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    autorun = false;
    layout = "us";
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
