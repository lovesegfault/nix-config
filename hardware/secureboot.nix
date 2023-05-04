{ config, lib, pkgs, ... }: {
  boot = {
    bootspec = {
      enable = true;
      enableValidation = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [ sbctl ];

  environment.persistence."/nix/state".directories = [ config.boot.lanzaboote.pkiBundle ];
}
