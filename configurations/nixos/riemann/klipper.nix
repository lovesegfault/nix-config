# Klipper, Moonraker and Mainsail for the Voron 2.4. The Leviathan runs as a
# USB-to-CAN bridge and the SB2209 toolhead sits on that bus.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  moonrakerDir = config.services.moonraker.stateDir;

  # Only the hardware that's connected so far: the Z motors, the LCD and the
  # fans. As the rest gets wired up, add ab.cfg, toolhead.cfg, bed.cfg and
  # homing.cfg and drop the matching stand-ins from bringup.cfg.
  #
  # Nix joins the fragments into one file instead of using Klipper's [include],
  # because SAVE_CONFIG refuses to override values set in an included file.
  printerCfg = pkgs.writeText "printer.cfg" (
    lib.concatMapStringsSep "\n" builtins.readFile [
      ./printer/base.cfg
      ./printer/z.cfg
      ./printer/display.cfg
      ./printer/nevermore.cfg
      ./printer/macros.cfg
      ./printer/bringup.cfg
    ]
  );
in
{
  services = {
    klipper = {
      enable = true;
      # Moonraker edits and serves Klipper's config, so both share one user.
      user = "moonraker";
      group = "moonraker";
      configDir = "${moonrakerDir}/config";
      # Regenerated from Nix on every start; the module carries over only the
      # SAVE_CONFIG section (PID, Z offset, meshes, input shaper).
      configFile = printerCfg;
      firmwares = {
        leviathan = {
          enable = true;
          configFile = ./firmware/leviathan.config;
        };
        sb2209 = {
          enable = true;
          configFile = ./firmware/sb2209.config;
        };
      };
    };

    moonraker = {
      enable = true;
      allowSystemControl = true;
      settings = {
        authorization = {
          # No logins on the LAN or tailnet. Mainsail only listens on IPv4
          # (below), so these cover every client that can reach it.
          trusted_clients = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "100.64.0.0/10" # tailnet
            "127.0.0.0/8"
            "::1/128"
          ];
          cors_domains = [
            "*://riemann"
            "*://riemann.local"
            "*://*.ts.net"
          ];
        };
        announcements.subscriptions = [ "mainsail" ];
        file_manager.enable_object_processing = true;
        history = { };
        octoprint_compat = { };
      };
    };

    mainsail = {
      enable = true;
      hostName = "riemann";
      nginx = {
        default = true;
        # IPv4 only: Moonraker trusts clients by address, and the LAN's IPv6
        # prefix is handed out by the ISP. With nothing on IPv6, browsers fall
        # back to the LAN or tailnet IPv4 address, which trusted_clients covers.
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  # vcgencmd for interactive use, and for Moonraker's throttle checking.
  environment.systemPackages = [ pkgs.libraspberrypi ];

  systemd.tmpfiles.rules = [
    # On first start Moonraker opens its log before creating logs/, so a fresh
    # install warns "Unable to create log file" until it restarts.
    "d ${moonrakerDir}/logs - moonraker moonraker - -"
    # Moonraker enables throttle and under-voltage checking only if this path
    # exists; it then queries the firmware over /dev/vcio itself.
    "L+ /usr/bin/vcgencmd - - - - ${pkgs.libraspberrypi}/bin/vcgencmd"
  ];

  # Let the video group use the firmware mailbox, as Raspberry Pi OS does.
  services.udev.extraRules = ''
    SUBSYSTEM=="misc", KERNEL=="vcio", GROUP="video", MODE="0660"
  '';
  users.users.moonraker.extraGroups = [ "video" ];

  # The Leviathan's USB-to-CAN bridge shows up as can0; its bitrate is fixed in
  # the firmware, but the link still needs one to come up. No RestartSec: the
  # bridge (gs_usb) can't restart from bus-off, and networkd then fails the
  # whole link.
  systemd.network = {
    links."10-can" = {
      matchConfig.Type = "can";
      linkConfig.TransmitQueueLength = 1024;
    };
    networks."10-can" = {
      matchConfig.Type = "can";
      canConfig.BitRate = 1000000;
      linkConfig.RequiredForOnline = "no";
    };
  };
}
