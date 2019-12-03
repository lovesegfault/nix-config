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
    kernelPackages = pkgs.linuxPackages_latest;
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
    xserver = {
      libinput = {
        accelProfile = "flat";
        accelSpeed = "0.7";
      };
      windowManager.i3.extraSessionCommands = ''
        export GDK_SCALE = "2";
        export GDK_DPI_SCALE = "0.5";
        export QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        xrdb -merge ~/.Xresources

        xrandr --output eDP1 --scale 0.5x0.5 --auto
      '';
    };
  };

  users.users.bemeurer.extraGroups = [ "camera" ];
}
