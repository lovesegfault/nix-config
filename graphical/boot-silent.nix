{
  boot = {
    consoleLogLevel = 1;
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_priority=3"
    ];
  };
}
