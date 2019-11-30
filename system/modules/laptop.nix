{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_5_3;

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;

  programs.light.enable = true;

  services.fwupd.enable = true;

  users.users.bemeurer.extraGroups = [ "camera" ];
}
