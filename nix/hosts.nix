let
  hosts = {
    aurelius = {
      type = "nixos";
      address = "100.92.104.42";
      localSystem = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8LfZJVnCw5Wq8+mym6uxTwg6+QhvkSjt0qfzap4C7w";
    };
    bohr = {
      type = "nixos";
      address = "100.123.20.5";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTh+kYOeeYoBuxvA00nGojfBHUQlXW3iF7aRIw9VbY1";
    };
    derrida = {
      type = "home-manager";
      localSystem = "x86_64-linux";
      homeDirectory = "/home/bemeurer";
    };
    foucault = {
      type = "nixos";
      address = "100.98.82.56";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0IrRSWNqfLBqXHlM0zpyP21/UGiztIQ+y3KDx+R7ux";
    };
    fourier = {
      type = "nixos";
      address = "100.77.106.120";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJEc036Z0umFUeSgksRgBWhcEeqiVhuXNQZTipZVRMn";
    };
    hegel = {
      type = "nixos";
      address = "100.102.43.14";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEARcffsBJMGM/vRiJ6jlBJcBz/UtT7FG3ZmE5Ybfuz6";
    };
    jung = {
      type = "nixos";
      address = "100.80.1.112";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHws1wwXYHDmU+Bjcbw8IZv2V+fbxaTDQc44XoUQ604t";
    };
    luther = {
      type = "home-manager";
      localSystem = "aarch64-linux";
      homeDirectory = "/home/bemeurer";
    };
    nozick = {
      type = "nixos";
      address = "100.124.29.84";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzb5JCgcXJZHDkY09vBAvIF34JabI+ZBpGqJDy6KbI";
    };
    poincare = {
      type = "darwin";
      localSystem = "aarch64-darwin";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYvFEyV+nebaTfrwAULWDmCk0L6O+1OyZc43JnizcIB";
    };
  };

  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  systemPred = system: (_: v: builtins.match ".*${system}.*" v.localSystem != null);

  genFamily = filter: hosts: rec {
    all = filterAttrs filter hosts;

    nixos = genFamily (_: v: v.type == "nixos") all;
    nix-darwin = genFamily (_: v: v.type == "darwin") all;
    homeManager = genFamily (_: v: v.type == "home-manager") all;

    darwin = genFamily (systemPred "-darwin") all;
    linux = genFamily (systemPred "-linux") all;

    aarch64-darwin = genFamily (systemPred "aarch64-darwin") all;
    aarch64-linux = genFamily (systemPred "aarch64-linux") all;
    x86_64-darwin = genFamily (systemPred "x86_64-darwin") all;
    x86_64-linux = genFamily (systemPred "x86_64-linux") all;
  };
in
genFamily (_: _: true) hosts
