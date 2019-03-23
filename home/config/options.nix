{ lib, config, ...}:
{
  options.isDesktop = lib.mkEnableOption "Is Desktop";
  options.isArm = lib.mkEnableOption "Uses an ARM CPU";
  options.iwFace = lib.mkOption {
    default = "wlan0";
    description = "Name of the wireless iface to use.";
    type = lib.types.str;
  };
  options.bgImage = lib.mkOption {
    default = "${config.home.homeDirectory}/pictures/walls/ocean.jpg";
    description = "Path to the background image";
  };
}
