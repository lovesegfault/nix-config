{ pkgs, ... }: {
  environment.systemPackages = with pkgs.gnome3; [ adwaita-icon-theme ];

  services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };

  systemd.packages = with pkgs.gnome3; [ gnome-session gnome-shell ];
}
