# Profile for AWS EC2 instances used as remote Nix builders.
# Hosts using this profile:
#   - networking.hostName is set dynamically by EC2, not in config
#   - age.rekey.localStorageDir must be set explicitly (hostname unknown at eval)
#   - age.secrets.rootPassword.rekeyFile must be set explicitly
{
  flake,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    "${modulesPath}/virtualisation/amazon-image.nix"

    self.nixosModules.default
    self.nixosModules.hardware-fast-networking
    self.nixosModules.hardware-no-mitigations
    self.nixosModules.pam-limits
    self.nixosModules.services-eternal-terminal
    self.nixosModules.services-podman
    self.nixosModules.users-bemeurer
  ];

  home-manager.users.bemeurer = {
    imports = [ self.homeModules.trusted ];
    programs.git.settings.user.email = lib.mkForce "beme@anthropic.com";
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment = {
    persistence."/nix/state".enable = false;
    systemPackages = with pkgs; [ awscli2 ];
  };

  programs.nix-ld.enable = true;

  stylix.targets.grub.enable = false;

  time.timeZone = lib.mkDefault "America/New_York";
}
