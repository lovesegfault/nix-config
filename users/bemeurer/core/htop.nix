{ config, ... }: {
  programs.htop = {
    enable = true;
    settings = {
      delay = 10;
      show_program_path = false;
    } // (with config.lib.htop;
      leftMeters {
        AllCPUs2 = modes.Bar;
        Memory = modes.Bar;
        Swap = modes.Bar;
      }
    ) // (with config.lib.htop;
      rightMeters {
        Hostname = modes.Text;
        Tasks = modes.Text;
        LoadAverage = modes.Text;
        Uptime = modes.Text;
        Systemd = modes.Text;
      }
    );
  };
}
