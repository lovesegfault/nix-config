{ pkgs, ... }: {
  boot = {
    earlyVconsoleSetup = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 2;
    };
    tmpOnTmpfs = true;
  };

}
