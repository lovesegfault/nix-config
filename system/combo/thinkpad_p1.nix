{ config, pkgs, ... }: {
  imports = [
    ../modules/bluetooth.nix
    ../modules/bumblebee.nix
    ../modules/fprint.nix
    ../modules/intel.nix
    ../modules/laptop.nix
    ../modules/tlp.nix
    ../modules/thunderbolt.nix
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      tp_smapi
    ];
    kernelModules = [ "acpi_call" ];
  };

  i18n = {
    consoleFont = "ter-v28n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

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
}
