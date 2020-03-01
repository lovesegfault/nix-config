{
  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_ENERGY_PERF_POLICY_ON_AC=performance
      CPU_ENERGY_PERF_POLICY_ON_BAT=power
      CPU_MAX_PERF_ON_AC=100
      CPU_MAX_PERF_ON_BAT=50
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave

      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth wifi"
      DEVICES_TO_ENABLE_ON_AC="bluetooth wifi"

      DISK_DEVICES="nvme0n1 sda"
      DISK_IOSCHED="mq-deadline bfq"

      MAX_LOST_WORK_SECS_ON_AC=15
      MAX_LOST_WORK_SECS_ON_BAT=15

      RUNTIME_PM_DRIVER_BLACKLIST="amdgpu nouveau nvidia radeon"

      USB_WHITELIST="1050:0407 056a:5193"
    '';
  };
}
