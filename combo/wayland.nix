{ lib, pkgs, ... }: {
  imports = [ ../modules/sway.nix ];

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  services.xserver = {
    displayManager.gdm.wayland = true;
    displayManager.gdm.nvidiaWayland = true;
    videoDrivers = lib.mkForce [ "modesetting" ];
  };
}
