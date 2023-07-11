{ home-manager, lib, nix-index-database, pkgs, stylix, ... }: {
  imports = [
    home-manager.darwinModules.home-manager
    nix-index-database.darwinModules.nix-index
    stylix.darwinModules.stylix
  ];

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
  };
}
