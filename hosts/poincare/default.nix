{ config, lib, pkgs, ... }: {
  imports = [
    ../../core

    ../../graphical

    ../../users/bemeurer
  ];

  environment.variables.JAVA_HOME = "$(/usr/libexec/java_home)";

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
    buildMachines = lib.mkForce [{
      hostName = "linux-builder";
      sshUser = "builder";
      sshKey = "/etc/nix/builder_ed25519";
      protocol = "ssh-ng";
      system = "${pkgs.stdenv.hostPlatform.uname.processor}-linux";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
      inherit (config.nix.linux-builder) maxJobs supportedFeatures;
    }];
    linux-builder = {
      enable = true;
      ephemeral = true;
      config = { ... }: {
        imports = [ ../../core/nix.nix ];
        _module.args.hostType = "nixos";
        virtualisation.host.pkgs = lib.mkForce (pkgs.extend (final: _: { nix = final.nixVersions.unstable; }));
      };
      maxJobs = 4;
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
