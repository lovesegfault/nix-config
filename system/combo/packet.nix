{ config, pkgs, ... }: {

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleFont = "ter-v28n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
