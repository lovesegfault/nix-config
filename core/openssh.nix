{ lib, ... }: {
  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    permitRootLogin = lib.mkDefault "no";
  };
}
