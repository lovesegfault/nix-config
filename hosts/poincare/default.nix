{ lib, pkgs, ... }: {
  imports = [
    ../../core

    ../../graphical

    ../../users/bemeurer
  ];

  environment = {
    variables.JAVA_HOME = "$(/usr/libexec/java_home)";
    systemPackages = [ (lib.hiPrio pkgs.opensshWithKerberos) ];
  };

  homebrew.casks = [
    { name = "podman-desktop"; greedy = true; }
  ];

  home-manager.users.bemeurer = { config, ... }: {
    imports = [ ../../users/bemeurer/dev/aws.nix ];
    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
  };

  nix = {
    gc.automatic = true;
    linux-builder = {
      enable = true;
      ephemeral = true;
      config = { ... }: {
        imports = [ ../../core/nix.nix ];
        _module.args.hostType = "nixos";
        virtualisation.host.pkgs = lib.mkForce (pkgs.extend (final: _: {
          nix = final.nixVersions.latest;
        }));
      };
      maxJobs = 4;
      protocol = "ssh-ng";
    };
    settings = {
      max-substitution-jobs = 20;
      system-features = [ "big-parallel" "gccarch-armv8-a" ];
      trusted-users = [ "bemeurer" ];
    };
  };

  users.users.bemeurer = {
    uid = 504;
    gid = 20;
  };
}
