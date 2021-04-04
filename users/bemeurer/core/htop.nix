{
  programs.htop = {
    enable = true;
    delay = 10;
    meters = {
      left = [ "AllCPUs2" "Memory" "Swap" ];
      right = [ "Hostname" "Tasks" "LoadAverage" "Uptime" ];
    };
    showProgramPath = false;
  };
}
