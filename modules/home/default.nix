# Shared home-manager configuration for all platforms
# External modules (impermanence, nix-index-database, nixvim, stylix) are imported in configurations/
{
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  # When integrated with NixOS/Darwin, osConfig is the parent system config
  # When standalone, osConfig is null
  isIntegrated = osConfig != null;
in
{
  imports = [
    ../shared/theme.nix
    ./bash.nix
    ./btop.nix
    ./custom
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./neovim
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
    ./dev
  ];

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    stateVersion = lib.mkDefault "25.11";
    packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
      with pkgs;
      [
        mosh
        nix-closure-size
        nix-output-monitor
        rsync
        truecolor-check
      ]
    );
    shellAliases = {
      cat = "bat";
      cls = "clear";
      l = "ls";
      la = "ls --all";
      ls = "eza --binary --header --long";
      man = "batman";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = [ "--disable-up-arrow" ];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    jq.enable = true;
    nh = {
      enable = true;
      flake = "git+https://github.com/lovesegfault/nix-config";
    };
    nix-index.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };

  stylix.targets = {
    # Only enable GNOME/GTK when integrated with NixOS (not standalone home-manager)
    gnome.enable = isIntegrated && pkgs.stdenv.isLinux;
    gtk.enable = isIntegrated && pkgs.stdenv.isLinux;
    kde.enable = lib.mkDefault false;
    xfce.enable = lib.mkDefault false;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
