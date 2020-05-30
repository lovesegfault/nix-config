{
  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = [ "kvm_intel" ];
  };

  virtualisation.libvirtd.enable = true;
}
