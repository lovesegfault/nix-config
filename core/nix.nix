{ config, pkgs, ... }: {
  nix = {
    allowedUsers = [ "@wheel" ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
    nrBuildUsers = config.nix.maxJobs * 2;
    optimise = {
      automatic = true;
      dates = [ "01:10" "12:10" ];
    };
    package = pkgs.nixUnstable;
    trustedUsers = [ "root" "@wheel" ];
  };
}
