{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix

    ../hardware/rpi3.nix

    ../modules/sshguard.nix
    ../modules/ddclient.nix

    ../../share/secrets/modules/ddclient-home-lovesegfault-com.nix
  ];

  networking.hostName = "bohr";

  time.timeZone = "America/Los_Angeles";
}
