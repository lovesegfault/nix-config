{ config, ... }:
{
  home.stateVersion = "25.11";

  # Only enable home-manager CLI for standalone configs
  # NixOS/nix-darwin manage home-manager at the system level
  programs.home-manager.enable = config.configKind == "home-manager";

  systemd.user.startServices = "sd-switch";
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  dconf.enable = false;
}
