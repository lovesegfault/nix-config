{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin brlaser canon-cups-ufr2 mfcl2750cupswrapper ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
