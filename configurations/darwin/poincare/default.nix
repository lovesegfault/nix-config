# Darwin configuration for poincare
{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = [
    # Internal modules via flake outputs
    self.darwinModules.default
    self.darwinModules.users-bemeurer
    self.darwinModules.graphical
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
      config = {
        imports = [ self.nixosModules.nix ];
        virtualisation.host.pkgs = lib.mkForce (
          pkgs.extend (final: _: { nix = final.nixVersions.latest; })
        );
        # qemu-vm.nix replaced 9p with virtiofs and now unconditionally reaches
        # for `hostPkgs.virtiofsd` to serve the default xchg/shared mounts.
        # virtiofsd is `platforms = linux`, so on a Darwin host that fails to
        # evaluate. A headless builder VM is driven over ssh-ng and never
        # touches those mounts, so drop them entirely.
        virtualisation.sharedDirectories = lib.mkForce { };
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
