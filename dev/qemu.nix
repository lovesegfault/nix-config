{
  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = [ "kvm_intel" ];
  };

  virtualisation = {
    kvmgt.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "suspend";
    };
  };
}
