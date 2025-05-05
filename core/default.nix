{
  pkgs,
  tinted-schemes,
  hostType,
  impermanence,
  nix-index-database,
  stylix,
  ...
}:
{
  imports = [
    (
      if hostType == "nixos" then
        ./nixos.nix
      else if hostType == "darwin" then
        ./darwin.nix
      else
        throw "Unknown hostType '${hostType}' for core"
    )
    ./aspell.nix
    ./nix.nix
  ];

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
    systemPackages =
      with pkgs;
      [
        neovim
        rsync
      ]
      ++ (lib.optional (hostType != "darwin") man-pages);
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        tinted-schemes
        hostType
        impermanence
        nix-index-database
        stylix
        ;
    };
  };

  programs = {
    nix-index.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${tinted-schemes}/base16/ayu-dark.yaml";
    # We need this otherwise the autoimport clashes with our manual import.
    homeManagerIntegration.autoImport = false;
    image = ../users/bemeurer/assets/walls/plants-00.jpg;
  };
}
