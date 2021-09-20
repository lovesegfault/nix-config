{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virt-manager spice-gtk ];
  security.polkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
