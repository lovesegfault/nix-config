{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.eternal-terminal.enable = true;

  networking.firewall.allowedTCPPorts = [ config.services.eternal-terminal.port ];

  # Hardening and correctness fixes for eternal-terminal. The upstream NixOS
  # module ships no sandboxing and uses Type=forking without a PIDFile, which
  # makes systemd lose track of the daemon (restarts then fail with
  # EADDRINUSE). Running in the foreground with Type=exec avoids that entirely
  # and routes logs to the journal.
  #
  # etserver forks user shells, so those shells inherit these restrictions —
  # options that would break interactive sessions (ProtectSystem, ProtectHome,
  # MemoryDenyWriteExecute, tight capability bounding) are deliberately
  # omitted. PrivateTmp is also omitted: etserver writes the SSH agent
  # forwarding socket to /tmp, and the user session (handed off to logind)
  # lands outside the service's mount namespace, so SSH_AUTH_SOCK would point
  # to a path that doesn't exist from the shell's view.
  systemd.services.eternal-terminal.serviceConfig =
    let
      etCfg = config.services.eternal-terminal;
      cfgFile = pkgs.writeText "et.cfg" ''
        [Networking]
        port = ${toString etCfg.port}

        [Debug]
        verbose = ${toString etCfg.verbosity}
        silent = ${if etCfg.silent then "1" else "0"}
        logsize = ${toString etCfg.logSize}
      '';
    in
    {
      Type = lib.mkForce "exec";
      ExecStart = lib.mkForce "${pkgs.eternal-terminal}/bin/etserver --logtostdout --cfgfile=${cfgFile}";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "@privileged"
        "~@clock"
        "~@module"
        "~@obsolete"
        "~@raw-io"
        "~@reboot"
        "~@swap"
      ];
      LockPersonality = true;
      UMask = "0077";
    };
}
