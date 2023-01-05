{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    disabledPlugins = [ "sap" ];
    settings = {
      General = {
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        Experimental = "true";
        KernelExperimental = "a6695ace-ee7f-4fb9-881a-5fac66c629af 6fbaf188-05e0-496a-9885-d6ddfdb4e03e";
      };
    };
  };
}
