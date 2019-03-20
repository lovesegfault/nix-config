{lib, ...}:
{
  options.isDesktop = lib.mkEnableOption "Is Desktop";
  options.isArm = lib.mkEnableOption "Uses an ARM CPU";
}
