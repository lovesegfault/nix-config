{ lib, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 15;
    };
    timeout = lib.mkDefault 2;
  };
  console.earlySetup = true;
}
