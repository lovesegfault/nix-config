let
  pkgs = import ./nix/nixpkgs.nix {};
  mkSystem = configuration: system:
    let
      nixos = import ./nix/nixos.nix;
      eval = (nixos { inherit configuration system; });
    in eval.system;

  systems = {
    abel = mkSystem ./systems/abel.nix "x86_64-linux";
    bohr = mkSystem ./systems/bohr.nix "aarch64-linux";
    camus = mkSystem ./systems/camus.nix "aarch64-linux";
    cantor = mkSystem ./systems/cantor.nix "x86_64-linux";
    foucault = mkSystem ./systems/foucault.nix "x86_64-linux";
    peano = mkSystem ./systems/peano.nix "x86_64-linux";
  };

  mkGceImage = configuration: system:
    let
      nixos = import ./nix/nixos.nix;
      gceImageModule = pkgs.path + "/nixos/modules/virtualisation/google-compute-image.nix";
      gceCfg = {
        imports = [ configuration gceImageModule ];
        virtualisation.googleComputeImage.diskSize = 10 * 1024;
      };
    in (nixos { inherit system; configuration = gceCfg; });

  gceImages = {
    sartre = mkGceImage ./systems/sartre.nix "x86_64-linux";
  };
in
{
  inherit pkgs gceImages;
  x86_64 = with systems; [ abel cantor foucault peano ];
  aarch64 = with systems; [ bohr camus ];

  shellBuildInputs = with pkgs; [
    cachix
    niv
    nixpkgs-fmt
    morph
    shfmt
    shellcheck
    ctags
  ];
} // systems
