{ home-manager, lib, nix-index-database, pkgs, stylix, ... }: {
  imports = [
    home-manager.darwinModules.home-manager
    nix-index-database.darwinModules.nix-index
    stylix.darwinModules.stylix
  ];

  environment = {
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
      ln -sv ${../nix/overlays} $out/overlays
    '';
    shells = with pkgs; [ fish zsh ];
    shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
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
      openssh_gssapi
    ];
    systemPath = lib.mkBefore [
      "/opt/homebrew/bin"
    ];
    variables = {
      SHELL = lib.getExe pkgs.fish;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    taps = [ "homebrew/core" ];
    brews = [ "git" "mas" ];
    masApps = {
      "Tailscale" = 1475387142;
    };
  };

  nix = {
    gc.automatic = true;
    settings.trusted-users = [ "root" "bemeurer" ];
  };

  programs.fish.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin";

  services.nix-daemon = {
    enable = true;
    logFile = "/var/log/nix-daemon.log";
  };

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    # We need this otherwise the autoimport clashes with our manual import.
    homeManagerIntegration.autoImport = false;
    # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };
  };

  system = {
    stateVersion = 4;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
}
