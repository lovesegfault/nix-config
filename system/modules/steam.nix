{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ steam steam-run ];

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;
}
