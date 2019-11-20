{ lib, ... }: {
  imports = [
    ../modules/i3.nix
    ../modules/xautolock.nix
    ../modules/xserver.nix
  ];

  services.xserver.displayManager.gdm.wayland = lib.mkForce false;
}
