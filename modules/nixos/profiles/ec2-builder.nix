# Profile for AWS EC2 instances used as remote Nix builders.
# Hosts using this profile:
#   - networking.hostName is set dynamically by EC2, not in config
#   - age.rekey.localStorageDir must be set explicitly (hostname unknown at eval)
#   - age.secrets.rootPassword.rekeyFile must be set explicitly
#   - /home/bemeurer/.ssh/bemeurer must be provisioned manually (git signing,
#     agenix-rekey master identity)
#   - EBS-image hosts must import amazon-image.nix themselves (keynes owns its layout via disko)
{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd

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
    programs.git.settings.user = {
      email = lib.mkForce "beme@anthropic.com";
      # SSH-only hosts: sign with the on-disk key (also the agenix-rekey
      # master identity) so signing never depends on a forwarded agent.
      # NB: lowercase "signingkey" — must match the attr set by
      # homeModules.trusted for the mkForce to apply to it.
      signingkey = lib.mkForce "/home/bemeurer/.ssh/bemeurer";
    };
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment = {
    persistence."/nix/state".enable = false;
    systemPackages = with pkgs; [ awscli2 ];
  };

  fileSystems."/nix/var/nix/builds" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=33%" # adjust for your situation and needs
      "mode=700"
      "huge=within_size"
    ];
  };

  programs.nix-ld.enable = true;

  stylix.targets.grub.enable = false;

  time.timeZone = lib.mkDefault "America/New_York";
}
