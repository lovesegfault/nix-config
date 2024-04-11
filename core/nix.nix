{ hostType, lib, pkgs, ... }: {
  nix = { } // lib.optionalAttrs (hostType == "nixos") {
    channel.enable = false;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  } // lib.optionalAttrs (hostType == "darwin") {
    daemonIOLowPriority = true;
  };
}
