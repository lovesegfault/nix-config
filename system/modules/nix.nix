{
  nix = {
    allowedUsers = [ "@wheel" ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    optimise = {
      automatic = true;
      dates = [ "01:10" "12:10" ];
    };
    trustedUsers = [ "root" "@wheel" ];
  };
}
