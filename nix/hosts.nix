let
  hosts = {
    aurelius = {
      type = "nixos";
      address = "100.92.35.75";
      hostPlatform = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8LfZJVnCw5Wq8+mym6uxTwg6+QhvkSjt0qfzap4C7w";
      remoteBuild = false;
    };
    bohr = {
      type = "nixos";
      address = "100.123.20.11";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTh+kYOeeYoBuxvA00nGojfBHUQlXW3iF7aRIw9VbY1";
      remoteBuild = true;
    };
    derrida = {
      type = "homeManager";
      hostPlatform = "x86_64-linux";
      homeDirectory = "/home/bemeurer";
    };
    goethe = {
      type = "homeManager";
      hostPlatform = "x86_64-linux";
      homeDirectory = "/home/bemeurer";
    };
    jung = {
      type = "nixos";
      address = "100.80.1.112";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHws1wwXYHDmU+Bjcbw8IZv2V+fbxaTDQc44XoUQ604t";
      remoteBuild = true;
    };
    luther = {
      type = "homeManager";
      hostPlatform = "aarch64-linux";
      homeDirectory = "/home/bemeurer";
    };
    nozick = {
      type = "nixos";
      address = "100.124.29.84";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzb5JCgcXJZHDkY09vBAvIF34JabI+ZBpGqJDy6KbI";
      remoteBuild = true;
    };
    poincare = {
      type = "darwin";
      hostPlatform = "aarch64-darwin";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYvFEyV+nebaTfrwAULWDmCk0L6O+1OyZc43JnizcIB";
    };
    spinoza = {
      type = "nixos";
      address = "100.68.240.30";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUZPmPTATZ4nBWstPqlUiguvxr26XWAE9BGPVNNRBR5";
      remoteBuild = true;
    };
  };

  inherit (builtins) attrNames concatMap listToAttrs filter;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  removeEmptyAttrs = filterAttrs (_: v: v != { });

  genSystemGroups = hosts:
    let
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      systemHostGroup = name: {
        inherit name;
        value = filterAttrs (_: host: host.hostPlatform == name) hosts;
      };
    in
    removeEmptyAttrs (listToAttrs (map systemHostGroup systems));

  genTypeGroups = hosts:
    let
      types = [ "darwin" "homeManager" "nixos" ];
      typeHostGroup = name: {
        inherit name;
        value = filterAttrs (_: host: host.type == name) hosts;
      };
    in
    removeEmptyAttrs (listToAttrs (map typeHostGroup types));

  genHostGroups = hosts:
    let
      all = hosts;
      systemGroups = genSystemGroups all;
      typeGroups = genTypeGroups all;
    in
    all // systemGroups // typeGroups // { inherit all; };
in
genHostGroups hosts
