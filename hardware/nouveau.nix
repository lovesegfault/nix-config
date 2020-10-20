{ pkgs, ... }: {
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ libva-full libvdpau-va-gl vaapiVdpau ];
    };
  };
}
