{ pkgs, ... }: {
  services.dbus.packages = with pkgs; [ gcr ];
}
