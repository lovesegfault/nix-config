let
  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  filterSystem = infix: filterAttrs (_: v: builtins.match ".*${infix}.*" v.localSystem != null);

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
    camus = {
      type = "nixos";
      address = "100.110.36.53";
      localSystem = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC1EjXv0xCbVitsGNuwbMp30/7N363/wBNkQJJhMFXRl";
    };
    deleuze = {
      type = "nixos";
      address = "100.91.202.65";
      localSystem = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPA2Ulu6atWys1O5u8NQom7Uy63RicmGbbOoFm8490p1";
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
    kant = {
      type = "nixos";
      address = "100.124.6.88";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkZdagumIM9Wvl6qwTjhEYdm9nC1ai5PSMpYbBPgsPL";
    };
    nozick = {
      type = "nixos";
      address = "100.124.29.84";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzb5JCgcXJZHDkY09vBAvIF34JabI+ZBpGqJDy6KbI";
    };
  };
in
{
  all = hosts;

  darwin = filterSystem "-darwin" hosts;
  linux = filterSystem "-linux" hosts;

  nixos = rec {
    all = filterAttrs (_: v: v.type == "nixos") hosts;

    darwin = filterSystem "-darwin" all;
    linux = filterSystem "-linux" all;

    aarch64 = filterSystem "aarch64-" all;
    x86_64 = filterSystem "x86_64" all;

    aarch64-linux = filterSystem "aarch64-linux" all;
    x86_64-linux = filterSystem "x86_64-linux" all;
  };

  homeManager = rec {
    all = filterAttrs (_: v: v.type == "home-manager") hosts;

    darwin = filterSystem "-darwin" all;
    linux = filterSystem "-linux" all;

    aarch64 = filterSystem "aarch64-" all;
    x86_64 = filterSystem "x86_64" all;

    aarch64-linux = filterSystem "aarch64-linux" all;
    aarch64-darwin = filterSystem "aarch64-darwin" all;
    x86_64-darwin = filterSystem "x86_64-darwin" all;
    x86_64-linux = filterSystem "x86_64-linux" all;
  };
}
