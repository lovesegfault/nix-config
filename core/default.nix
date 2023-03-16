{ lib, pkgs, hostType, impermanence, nix-index-database, ... }: {
  imports = [
    ./aspell.nix
    ./nix.nix
  ]
  ++ lib.optional (hostType == "nixos") ./nixos.nix
  ++ lib.optional (hostType == "darwin") ./darwin.nix
  ;

  environment = {
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      neovim
      rsync
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    extraSpecialArgs = {
      inherit impermanence nix-index-database;
    };
  };

  programs = {
    nix-index.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };
}
