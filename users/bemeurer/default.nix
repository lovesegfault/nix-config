{ config, lib, pkgs, ... }:
with lib;
{
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "wheel" ]
      ++ optionals config.programs.sway.enable [ "input" "video" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2 bemeurer.personal"
    ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    uid = 8888;
    hashedPassword = "$6$rounds=65536$iIIt7MZ7K0ghK$HMPPLFtp7SpvpLAajlgZp.sH2rCNsOq41E1CDCGCaxyz/tXSqWngalatM0V5zsMbj/4klKdAzeoOw1rZj7fp6/";
  };

  secrets.files.stcg-arcanist-config = pkgs.mkSecret {
    file = ../../secrets/stcg-arcanist-config;
    user = "bemeurer";
  };
  home-manager.users.bemeurer =
    mkMerge (
      [
        (import ./core)
        (import ./dev)
        ({ ... }: { home.file.arcrc = { source = config.secrets.files.stcg-arcanist-config.file; target = ".arcrc"; }; })
      ] ++ optionals config.programs.sway.enable [
        (import ./gpg)
        (import ./sway)
        (import ./music)
        (import ./impermanence.nix)
      ]
    );
}
