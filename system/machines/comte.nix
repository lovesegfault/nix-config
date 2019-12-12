{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../combo/optiplex-3070.nix
  ];

  networking.hostName = "comte";

  users.users.exclusivor = {
    createHome = true;
    isNormalUser = true;
    hashedPassword =
      "$6$KpUi.HX9QiHUWD$ITJ42rfXV2PTR5fFeGcbBrevFNrzL1aSUHVqxBFd8350WqhjyzK4gWnUCaq3pDYZGNZiNLisZgxts1QvNQthN1";
  };

  time.timeZone = "America/Los_Angeles";
}
