{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ man-pages ];
  documentation = {
    dev.enable = true;
    man.enable = true;
    info.enable = lib.mkForce false;
  };
}
