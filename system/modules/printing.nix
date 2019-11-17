{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint cups-googlecloudprint ];
  };
}
