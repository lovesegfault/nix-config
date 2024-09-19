let
  hasSuffix = suffix: content:
    let
      inherit (builtins) stringLength substring;
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix
  ;

  mkHost =
    { type
    , hostPlatform
    , address ? null
    , pubkey ? null
    , homeDirectory ? null
    , remoteBuild ? true
    , large ? false
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit type hostPlatform address pubkey remoteBuild large;
      }
    else if type == "darwin" then
      assert pubkey != null;
      assert (hasSuffix "darwin" hostPlatform);
      {
        inherit type hostPlatform pubkey large;
      }
    else if type == "home-manager" then
      assert homeDirectory != null;
      {
        inherit type hostPlatform homeDirectory large;
      }
    else throw "unknown host type '${type}'";
in
{
  aurelius = mkHost {
    type = "nixos";
    address = "100.69.178.40";
    hostPlatform = "aarch64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRlfGCSK2w34ckIGoRHaZ01CbF/7Zk4VNmyokkvg7cF";
    remoteBuild = false;
  };
  bohr = mkHost {
    type = "nixos";
    address = "100.123.20.11";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTh+kYOeeYoBuxvA00nGojfBHUQlXW3iF7aRIw9VbY1";
  };
  fourier = mkHost {
    type = "nixos";
    address = "100.77.107.1";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJEc036Z0umFUeSgksRgBWhcEeqiVhuXNQZTipZVRMn";
  };
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
  nozick = mkHost {
    type = "nixos";
    address = "100.124.29.84";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzb5JCgcXJZHDkY09vBAvIF34JabI+ZBpGqJDy6KbI";
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
  riemann = mkHost {
    type = "nixos";
    address = "100.67.173.60";
    hostPlatform = "aarch64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2gbNVSmk+N93wP0bdPrHsXAsJtKEFVf0TPZLCc0Vk+";
  };
  spinoza = mkHost {
    type = "nixos";
    address = "100.68.240.30";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUZPmPTATZ4nBWstPqlUiguvxr26XWAE9BGPVNNRBR5";
    large = true;
  };
  trotsky = mkHost {
    type = "home-manager";
    hostPlatform = "aarch64-linux";
    homeDirectory = "/home/bemeurer";
  };
}
