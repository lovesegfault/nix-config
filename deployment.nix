let
  pkgs = import ./nix/nixpkgs.nix {};
in
{
  network.description = "Bernardo's Hosts";

  "home.meurer.org" = import ./systems/bohr.nix; # should be aarch64
  "irc.meurer.org" = import ./systems/sartre.nix; # should be x86_64
  "localhost" = import ./systems/foucault.nix; # should be x86_64
  "srv0003.s0005.sjc.stcg.nonstandard.ai" = import ./systems/cantor.nix; # should be x86_64
}
