{
  networking.firewall = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 139 ];
  };

  services.samba = {
    enable = true;
    extraConfig = ''
      hosts allow = 10.0.0.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      ntlm auth = ntlmv1-permitted
      min protocol = NT1
    '';
    shares = {
      atabachnik = {
        path = "/srv/documents/atabachnik";
        "read only" = "yes";
        browseable = "yes";
        "guest ok" = "yes";
      };
      music = {
        path = "/srv/music";
        "read only" = "yes";
        browseable = "yes";
        "guest ok" = "yes";
      };
    };
  };
}
