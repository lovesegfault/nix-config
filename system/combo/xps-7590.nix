{ pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
    ../modules/thunderbolt.nix
    ../modules/tlp.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  i18n.consoleKeyMap = "us";

  nixpkgs.config.allowUnfree = true;

  programs.light.enable = true;

  services.fstrim.enable = true;

  users.users.bemeurer.extraGroups = [ "camera" ];
}
