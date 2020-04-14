{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin brlaser canon-cups-ufr2 ];
  };
}
