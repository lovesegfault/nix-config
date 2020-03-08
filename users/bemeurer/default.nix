{ lib, pkgs, ... }: {
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2 bemeurer.personal"
    ];
  };
  home-manager.users.bemeurer = lib.mkMerge [
    (import ./core { inherit pkgs; })
    (import ./dev)
    (import ./gpg)
    (import ./music)
    (import ./sway)
  ];
}
