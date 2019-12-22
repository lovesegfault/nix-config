{ pkgs, ... }: {
  boot.kernelParams = [ "intel_iommu=on" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libva
        intel-media-driver
        intel-compute-runtime
      ];
    };
  };

  services.xserver.useGlamor = true;
}
