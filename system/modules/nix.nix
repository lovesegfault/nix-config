{
  nix = {
    allowedUsers = [ "@wheel" ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    maxJobs = 12;
    optimise = {
      automatic = true;
      dates = [ "01:10" "12:10" ];
    };
    trustedUsers = [ "root" "@wheel" ];
  };
}
