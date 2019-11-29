{
  services.tlp = {
    enable = true;
    extraConfig = ''
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
      DISK_IOSCHED="mq-deadline bfq"
    '';
  };
}
