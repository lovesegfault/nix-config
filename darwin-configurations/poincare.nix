{ ezModules, inputs, lib, pkgs, ... }: {
  imports = [
    # ../users/bemeurer
  ];

  nix-config.core.enable = true;
  nix-config.graphical.enable = true;

  environment.variables.JAVA_HOME = "$(/usr/libexec/java_home)";

  homebrew.casks = [
    { name = "podman-desktop"; greedy = true; }
  ];

  # home-manager.users.bemeurer = { config, ... }: {
  #   imports = [ ../users/bemeurer/dev/aws.nix ];
  #   home.sessionPath = [
  #     "${config.home.homeDirectory}/.local/bin"
  #   ];
  # };

  nix = {
    gc.automatic = true;
    linux-builder = {
      enable = true;
      ephemeral = true;
      config = { ... }: {
        _module.args = { inherit inputs; };
        imports = [ ../shared-modules/core/nix.nix ];
        virtualisation.host.pkgs = lib.mkForce (pkgs.extend (final: _: {
          nix = final.nixVersions.unstable;
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

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.bemeurer = {
    uid = 504;
    gid = 20;
  };
}
