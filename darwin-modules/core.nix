{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.nix-config.core;
in
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    inputs.stylix.darwinModules.stylix
    ../shared-modules/core
  ];

  config = lib.mkIf cfg.enable {
    environment = {
      shells = with pkgs; [ fish zsh ];
      systemPackages = with pkgs; [
        coreutils
        findutils
        gawk
        git
        gnugrep
        gnused
        gnutar
        gnutls
        ncurses
        openssh
      ];
      systemPath = lib.mkBefore [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];
      variables = {
        SHELL = lib.getExe pkgs.zsh;
      };
      postBuild = ''
        ln -sv ${pkgs.path} $out/nixpkgs
      '';
    };

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      brews = [ "git" ];
    };

    programs.fish.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin";

    services = {
      nix-daemon = {
        enable = true;
        logFile = "/var/log/nix-daemon.log";
      };
      tailscale.enable = true;
    };

    system = {
      stateVersion = 4;
      defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      includeUninstaller = false;
    };
  };
}
