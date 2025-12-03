{
  flake,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) self;
in
{
  imports = with self.darwinModules; [
    aspell
    common
    nix
    nixpkgs
    registry
    theme
  ];

  environment = {
    shells = with pkgs; [
      fish
      zsh
    ];
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
    extraSetup = ''
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
    nix-daemon.logFile = "/var/log/nix-daemon.log";
    tailscale.enable = lib.mkForce false; # enabled through homebrew
  };

  system = {
    stateVersion = 6;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    tools.darwin-uninstaller.enable = false;
  };
}
