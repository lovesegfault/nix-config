{ pkgs, ... }: {
  imports = [
    ../modules/aarch64-build-box.nix
    ../modules/bluetooth.nix
    ../modules/fwupd.nix
    ../modules/openssh.nix
    ../modules/sound.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleFont = "ter-v16n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
  };

  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = true;
}
