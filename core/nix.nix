{ config, pkgs, ... }: {
  nix = {
    allowedUsers = [ "@wheel" ];
    binaryCaches = [ "https://nix-config.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
    ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    distributedBuilds = true;
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
