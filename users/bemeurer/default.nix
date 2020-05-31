{ config, lib, pkgs, ... }:
with lib;
{
  secrets.stcg-arcanist-config = {
    file =
      let
        path = ../../secrets/stcg-arcanist-config;
      in
      if builtins.pathExists path then path else builtins.toFile "stcg-arcanist-config" "";
    user = "bemeurer";
  };

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

  home-manager.users.bemeurer =
    mkMerge (
      [
        (import ./core)
        (import ./dev)
        ({ ... }: { home.file.arcrc = { source = config.secrets.stcg-arcanist-config.file; target = ".arcrc"; }; })
      ] ++ optionals config.programs.sway.enable [
        (import ./gpg)
        (import ./sway)
        (import ./music)
      ]
    );
}
