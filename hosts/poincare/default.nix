{ lib, pkgs, ... }:
{
  imports = [
    ../../core

    ../../graphical

    ../../users/bemeurer
  ];

  networking = {
    computerName = "poincare";
    hostName = "poincare";
  };

  nix = {
    gc.automatic = true;
    linux-builder = {
      enable = true;
      ephemeral = true;
      config =
        { ... }:
        {
          imports = [ ../../core/nix.nix ];
          _module.args.hostType = "nixos";
          virtualisation.host.pkgs = lib.mkForce (
            pkgs.extend (
              final: _: {
                nix = final.nixVersions.latest;
              }
            )
          );
        };
      maxJobs = 4;
      protocol = "ssh-ng";
    };
    settings = {
      max-substitution-jobs = 20;
      system-features = [
        "big-parallel"
        "gccarch-armv8-a"
      ];
      trusted-users = [ "bemeurer" ];
    };
  };

  users.users.bemeurer = {
    uid = 502;
    gid = 20;
  };

  system.primaryUser = "bemeurer";

  ids.gids.nixbld = 350;
}
