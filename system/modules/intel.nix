{ pkgs, ... }: {
  boot.kernelParams = [ "intel_iommu=on" ];
  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiIntel vaapiVdpau libvdpau-va-gl ];
    };
  };
  services.xserver.useGlamor = true;

}
