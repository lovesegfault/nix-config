let
  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs
      (concatMap
        (name:
          let
            value = set.${name};
          in
          if pred name value
          then [{ inherit name value; }]
          else [ ]
        )
        (attrNames set)
      );

  allHosts = {
    aurelius = {
      type = "nixos";
      address = "100.92.104.42";
      localSystem = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8LfZJVnCw5Wq8+mym6uxTwg6+QhvkSjt0qfzap4C7w";
    };
    beme-cloudtop = {
      type = "home-manager";
      localSystem = "x86_64-linux";
      username = "beme";
      homeDirectory = "/usr/local/google/home/beme";
    };
    beme-glaptop = {
      type = "home-manager";
      localSystem = "x86_64-linux";
      username = "beme";
      homeDirectory = "/home/beme";
    };
    bohr = {
      type = "nixos";
      address = "100.123.20.5";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTh+kYOeeYoBuxvA00nGojfBHUQlXW3iF7aRIw9VbY1";
    };
    camus = {
      type = "nixos";
      address = "100.93.239.123";
      localSystem = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHiPgCtFeaDbb1dVlr0PU+QGhb1PxXn371BsWzeOoIQ";
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
    kant = {
      type = "nixos";
      address = "100.124.6.88";
      localSystem = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkZdagumIM9Wvl6qwTjhEYdm9nC1ai5PSMpYbBPgsPL";
    };
  };
in
{
  inherit allHosts;
  nixosHosts = filterAttrs (_: v: v.type == "nixos") allHosts;
  homeManagerHosts = filterAttrs (_: v: v.type == "home-manager") allHosts;
}
