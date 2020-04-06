{ config, lib, pkgs, ... }:
with lib;
{
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "wheel" ]
    ++ optionals config.programs.sway.enable [ "input" "video" ]
    ++ optionals config.networking.networkmanager.enable [ "networkmanager" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2 bemeurer.personal"
    ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    uid = 8888;
  };

  home-manager.users.bemeurer = lib.mkMerge (
    [
      (import ./core)
      (import ./dev)
    ] ++ optionals config.programs.sway.enable [
      (import ./gpg)
      (import ./sway)
      (import ./music)
    ]
  );
}
