{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../combo/thinkpad-p1.nix

    ../modules/keybase.nix

    ../modules/aarch64-build-box.nix

    ../modules/stcg-cachix.nix
    ../modules/stcg-cameras.nix
  ];

  networking.hostName = "foucault";

  time.timeZone = "America/Los_Angeles";

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      subnet 10.1.2.0 netmask 255.255.255.0 {
        range 10.1.2.0 10.1.2.10;
      }
    '';
    interfaces = [ "enp0s31f6" ];
  };
}
