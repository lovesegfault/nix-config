{ lib, pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 2;
    };
    tmpOnTmpfs = true;
  };
  console.earlySetup = true;
}
