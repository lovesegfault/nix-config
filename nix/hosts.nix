let
  hasSuffix =
    suffix: content:
    let
      inherit (builtins) stringLength substring;
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent content == suffix;

  mkHost =
    {
      type,
      hostPlatform,
      address ? null,
      pubkey ? null,
      homeDirectory ? null,
      remoteBuild ? true,
      large ? false,
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit
          type
          hostPlatform
          address
          pubkey
          remoteBuild
          large
          ;
      }
    else if type == "darwin" then
      assert pubkey != null;
      assert (hasSuffix "darwin" hostPlatform);
      {
        inherit
          type
          hostPlatform
          pubkey
          large
          ;
      }
    else if type == "home-manager" then
      assert homeDirectory != null;
      {
        inherit
          type
          hostPlatform
          homeDirectory
          large
          ;
      }
    else
      throw "unknown host type '${type}'";
in
{
  goethe = mkHost {
    type = "home-manager";
    hostPlatform = "x86_64-linux";
    homeDirectory = "/home/bemeurer";
  };
  hilbert = mkHost {
    type = "home-manager";
    hostPlatform = "x86_64-linux";
    homeDirectory = "/home/bemeurer";
  };
  jung = mkHost {
    type = "nixos";
    address = "100.80.1.112";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHws1wwXYHDmU+Bjcbw8IZv2V+fbxaTDQc44XoUQ604t";
  };
  plato = mkHost {
    type = "nixos";
    address = "100.101.152.88";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMExNPuG3+sl9qozno4cTmPEJSH8GGhoaReQsnpFaih";
  };
  poincare = mkHost {
    type = "darwin";
    hostPlatform = "aarch64-darwin";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYvFEyV+nebaTfrwAULWDmCk0L6O+1OyZc43JnizcIB";
  };
  popper = mkHost {
    type = "home-manager";
    hostPlatform = "aarch64-linux";
    homeDirectory = "/home/bemeurer";
  };
  spinoza = mkHost {
    type = "nixos";
    address = "100.68.240.30";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUZPmPTATZ4nBWstPqlUiguvxr26XWAE9BGPVNNRBR5";
  };
  trotsky = mkHost {
    type = "home-manager";
    hostPlatform = "aarch64-linux";
    homeDirectory = "/home/bemeurer";
  };
}
