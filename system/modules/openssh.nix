rec {
  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
    ports = [ 22 55888 ];
  };

  networking.firewall.allowedTCPPorts = services.openssh.ports;
}
