{ pkgs, ... }: {
  programs.ssh.startAgent = true;
  services.dbus.packages = with pkgs; [ gcr ];
}
