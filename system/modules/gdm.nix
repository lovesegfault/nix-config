{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = true;
      };
      extraSessionFilePackages = [ pkgs.sway ];
    };
  };
}
