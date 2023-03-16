{ lib, pkgs, hostType, impermanence, nix-index-database, ... }: {
  imports = [
    ./aspell.nix
    ./nix.nix
  ]
  ++ lib.optional (hostType == "nixos") ./nixos.nix
  ++ lib.optional (hostType == "darwin") ./darwin.nix
  ;

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    info.enable = true;
  };

  environment = {
    pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      man-pages
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
