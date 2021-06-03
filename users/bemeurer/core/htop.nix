{ config, ... }: {
  programs.htop = {
    enable = true;
    settings = {
      delay = 10;
      show_program_path = false;
    } // (with config.lib.htop; leftMeters [
      (bar "AllCPUs2")
      (bar "Memory")
      (bar "Swap")
    ]) // (with config.lib.htop; rightMeters [
      (text "Hostname")
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
      (text "Systemd")
    ]);
  };
}
