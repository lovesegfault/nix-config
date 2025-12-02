# Darwin configuration for poincare
{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    inputs.stylix.darwinModules.stylix

    # Internal modules via flake outputs
    self.darwinModules.default
    self.darwinModules.users-bemeurer
    self.darwinModules.graphical-default
  ];

  # Host-specific home-manager user config
  home-manager.users.bemeurer = {
    imports = [ self.homeModules.trusted ];
    # c.f. https://github.com/danth/stylix/issues/865
    nixpkgs.overlays = lib.mkForce null;
    programs.git.settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Nix registry
  nix.registry.p.flake = inputs.nixpkgs;

  # Host-specific configuration
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
          imports = [ self.nixosModules.nix ];
          virtualisation.host.pkgs = lib.mkForce (
            pkgs.extend (final: _: { nix = final.nixVersions.latest; })
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
