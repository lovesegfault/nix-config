{
  services.tlp = {
    enable = true;
    extraConfig = ''
      # Set Intel P-state performance: 0..100 (%).
      # Limit the max/min P-state to control the power dissipation of the CPU.
      # Values are stated as a percentage of the available performance.
      # Requires an Intel Core i processor with intel_pstate driver.
      # Default: <none>
      CPU_MIN_PERF_ON_AC=0
      CPU_MAX_PERF_ON_AC=100
      CPU_MIN_PERF_ON_BAT=0
      CPU_MAX_PERF_ON_BAT=33

      # Select I/O scheduler for the disk devices.
      # Multi queue (blk-mq) schedulers:
      #   mq-deadline(*), none, kyber, bfq
      # Single queue schedulers:
      #   deadline(*), cfq, bfq, noop
      # (*) recommended.
      # Separate values for multiple disks with spaces. Use the special value 'keep'
      # to keep the kernel default scheduler for the particular disk.
      # Notes:
      # - Multi queue (blk-mq) may need kernel boot option 'scsi_mod.use_blk_mq=1'
      #   and 'modprobe mq-deadline-iosched|kyber|bfq' on kernels < 5.0
      # - Single queue schedulers are legacy now and were removed together with
      #   the old block layer in kernel 5.0
      # Default: keep
      DISK_IOSCHED="mq-deadline"

      # Dirty page values (timeouts in secs).
      # Default: 15 (AC + BAT)
      MAX_LOST_WORK_SECS_ON_AC=15
      MAX_LOST_WORK_SECS_ON_BAT=15
    '';
  };
}
