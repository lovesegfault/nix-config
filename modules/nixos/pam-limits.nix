# PAM login limits for workstation/server hosts
# Provides generous limits for memory locking, file descriptors, and processes.
# Platform: NixOS only
{
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "1048576";
    }
    {
      domain = "*";
      type = "-";
      item = "nproc";
      value = "unlimited";
    }
  ];
}
