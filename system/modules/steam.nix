{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ steam steam-run ];

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
  };

  services.xserver.desktopManager.gnome3.enable = true;

  nixpkgs.config.allowUnfree = true;
}
