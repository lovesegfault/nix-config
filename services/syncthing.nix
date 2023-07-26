{ config, ... }:
with config.networking;
{
  environment.persistence."/nix/state".directories = [
    { directory = "/var/lib/syncthing"; inherit (config.services.syncthing) user group; }
  ];

  security.acme.certs."syncthing.${hostName}.meurer.org" = { };

  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        bohr.id = "QIBE7XV-ALGJQ7U-OY57XR6-QPCBXEF-7C7XD6B-RJFU3BM-3AOVBA5-OIOBLQH";
        fourier.id = "3X4DU22-5YRJF6K-VZCJJNE-5NPVKFJ-LYKWFDD-GYICDKZ-B7MDN73-4BXTMAT";
        jung.id = "GXCBSO2-RQAR3CC-ACW6JWB-IAZHQZO-XZWSYKL-SYB2GNS-T4R5QO2-Q76BXAV";
        nozick.id = "SJH2ZVC-EUWTL4M-ZEP57G6-O5A6DYX-4AWZU7C-XF4GGED-5F6OHGC-KDHPMA6";
      };
      gui = {
        insecureSkipHostcheck = true;
        insecureAdminAccess = true;
      };
    };
  };

  services.nginx.virtualHosts."syncthing.${hostName}.meurer.org" = {
    useACMEHost = "syncthing.${hostName}.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://${config.services.syncthing.guiAddress}";
  };

  services.oauth2_proxy.nginx.virtualHosts = [ "syncthing.${hostName}.meurer.org" ];
}
