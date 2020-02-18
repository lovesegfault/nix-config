{ pkgs, ... }: {
  boot.kernelParams = [ "intel_iommu=on" "i915.enable_guc=2" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      extraPackages = with pkgs; [
        vaapiIntel
        libva-full
        libvdpau-va-gl
        intel-media-driver
        intel-compute-runtime
      ];
    };
  };

  services.xserver.useGlamor = true;
}
