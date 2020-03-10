let
  mkSystem = cfg: system:
    let
      pkgs = import ./nix/nixpkgs.nix { inherit system; config.allowUnfree = true; };
    in
    {
      imports = [ cfg ];
      nixpkgs.pkgs = pkgs;
    };
in {
  network = {
    description = "Bernardo's Hosts";
  };

  # Personal
  "home.meurer.org" = mkSystem ./systems/bohr.nix "aarch64-linux";
  "irc.meurer.org" = mkSystem ./systems/sartre.nix "x86_64-linux";
  "localhost" = mkSystem ./systems/foucault.nix "x86_64-linux";

  # Sc
  "10.1.16.11" = mkSystem ./systems/peano.nix "x86_64-linux";
  "10.1.16.12" = mkSystem ./systems/abel.nix "x86_64-linux";
  "srv0003.s0005.sjc.stcg.nonstandard.ai" = mkSystem ./systems/cantor.nix "x86_64-linux";
}
