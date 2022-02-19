{ pkgs, ... }: {
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
    '';
    kernelModules = [ "kvm_intel" ];
    kernelParams = [ "intel_iommu=on" ];
    initrd = {
      kernelModules = [ "i915" ];
      extraModprobeConfig = ''
        options i915 enable_guc=2 enable_fbc=1 fastboot=1
      '';
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      extraPackages = with pkgs; [
        intel-compute-runtime # OpenCL
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  services.xserver.useGlamor = true;
}
