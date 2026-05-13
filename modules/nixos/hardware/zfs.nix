{ lib, pkgs, ... }:
{
  boot.supportedFilesystems = [ "zfs" ];

  # nixpkgs warns when this is left at its implicit default of true because the
  # default flips to false in 26.11. Keep force-import enabled explicitly: our
  # pools are always single-attached so the shared-storage corruption risk that
  # `-f` guards against doesn't apply, and disabling it only makes boot less
  # forgiving (e.g. after a rescue-shell import with a mismatched hostid).
  # mkDefault so a per-host config can opt out once a pool warrants it.
  boot.zfs.forceImportRoot = lib.mkDefault true;

  environment.systemPackages = with pkgs; [ zfs ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    trim = {
      enable = true;
      interval = "weekly";
    };
  };
}
