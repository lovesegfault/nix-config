{ pkgs, ... }: {
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.pcscd.enable = true;
}
