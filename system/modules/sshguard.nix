{
  services.sshguard = {
    enable = true;
    attack_threshold = 10;
    blacklist_threshold = 30;
    blocktime = 240;
    detection_time = 28800;
  };
}
