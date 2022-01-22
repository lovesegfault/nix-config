{ lib, ... }: {
  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = lib.mkDefault "no";
  };
}
