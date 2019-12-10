{
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
    ports = [ "22" "55888" ];
  };
}
