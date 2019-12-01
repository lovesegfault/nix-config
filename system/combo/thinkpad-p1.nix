{ config, pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/fwupd.nix
    ../modules/intel.nix
    ../modules/thunderbolt.nix
    ../modules/tlp.nix
  ];

  boot = rec {
    extraModulePackages = with kernelPackages; [ acpi_call tp_smapi ];
    kernelModules = [ "acpi_call" ];
    kernelPackages = pkgs.linuxPackages_5_3;
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleFont = "ter-v28n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.light.enable = true;

  services = {
    fprintd.package = pkgs.fprintd-thinkpad;
    fstrim.enable = true;
    undervolt = {
      enable = true;
      coreOffset = "-70";
      temp = "95";
    };

    xserver.libinput.accelSpeed = "0.7";
  };

  users.users.bemeurer.extraGroups = [ "camera" ];
}
