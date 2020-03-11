{ lib, pkgs, ... }: {
  imports = [
    ../core

    ../dev
    ../dev/stcg-cachix.nix

    ../hardware/stcg-dc.nix
  ] ++ (import ../users).stream;

  environment.systemPackages = with pkgs; [ fahviewer fahcontrol ];
  services.foldingathome.enable = true;
  networking.firewall.allowedTCPPorts = [ 36330 ];
  systemd.services.foldingathome.wantedBy = lib.mkForce [];


  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4d662b7c-e395-49d6-86ad-237ed28eb885";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/41D0-C874";
      fsType = "vfat";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e4cdc2fd-eda2-45dd-a250-ea08a5250b9e"; } ];

  networking = {
    hostName = "cantor";
    hostId = "e387c8da";
  };

  time.timeZone = "America/Los_Angeles";
  virtualisation.docker.enable = true;
}
