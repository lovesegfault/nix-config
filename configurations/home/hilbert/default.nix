# Home-manager configuration for hilbert
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs self;
in
{
  imports = [
    # External input modules
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
    inputs.stylix.homeModules.stylix

    # Internal modules via flake outputs
    self.homeModules.default
    self.homeModules.standalone
    self.homeModules.terminfo-hack
  ];

  # Home settings
  home = {
    username = lib.mkForce "argocd";
    homeDirectory = "/root";
    uid = 999;
    stateVersion = "25.11";
    file.".ssh/config".enable = false;
    packages = with pkgs; [ nixVersions.latest ];
    sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];
  };

  # Nix registry
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    p.flake = inputs.nixpkgs;
  };

  programs = {
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi
      '';
      profileExtra = ''
        if [ -f /etc/profile ]; then
          . /etc/profile
        fi
      '';
    };
    git.settings = {
      user.email = lib.mkForce "beme@anthropic.com";
      gpg = lib.mkForce { format = "ssh"; };
      commit.gpgsign = true;
    };
    zsh.initContent = lib.mkOrder 0 ''
      if [[ "$ZSH_VERSION" != "${config.programs.zsh.package.version}" ]]; then
        exec "${config.programs.zsh.package}/bin/zsh"
      fi
    '';
  };
}
