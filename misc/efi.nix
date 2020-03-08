{ lib, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = lib.mkDefault 2;
    };
    tmpOnTmpfs = true;
  };
  console.earlySetup = true;
}
