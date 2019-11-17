{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;

  programs.light.enable = true;

  services.fwupd.enable = true;
}
