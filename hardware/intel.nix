{ nixos-hardware, pkgs, ... }: {
  imports = [ nixos-hardware.common-cpu-intel ];
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options i915 enable_guc=3 enable_fbc=1 fastboot=1
    '';
    kernelModules = [ "kvm_intel" ];
    kernelParams = [ "intel_iommu=on" ];
  };

  environment.systemPackages = with pkgs; [ intel-gpu-tools ];
}
