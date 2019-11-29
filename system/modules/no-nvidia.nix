{ config, ... }: {
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = with config.boot.kernelPackages; [ bbswitch ];
    extraModprobeConfig = ''
      options bbswitch load_state=0 unload_state=1
    '';
    kernelModules = [ "bbswitch" ];
  };
}
