{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/graphical.nix
    ../combo/wayland.nix
    ../combo/optiplex-3070.nix
  ];

  networking.hostName = "comte";

  nix.trustedUsers = [ "exclusivor" ];

  services.xserver.displayManager.gdm.autoLogin = {
    enable = true;
    user = "exclusivor";
  };

  users.users.cloud = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfPRiesz2VviTkRJAd3mzGRm2P+K67SutblfJ9I1+rU cloud@standard.ai"
    ];
    shell = pkgs.zsh;
  };

  users.users.exclusivor = {
    createHome = true;
    isNormalUser = true;
    hashedPassword =
      "$6$KpUi.HX9QiHUWD$ITJ42rfXV2PTR5fFeGcbBrevFNrzL1aSUHVqxBFd8350WqhjyzK4gWnUCaq3pDYZGNZiNLisZgxts1QvNQthN1";
    shell = pkgs.zsh;
  };

  time.timeZone = "America/Los_Angeles";
}
