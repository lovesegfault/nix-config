{ pkgs, ... }: {
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint cups-googlecloudprint canon-cups-ufr2 ];
  };
}
