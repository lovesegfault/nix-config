{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    disabledPlugins = [ "sap" ];
    settings = {
      General = {
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
}
