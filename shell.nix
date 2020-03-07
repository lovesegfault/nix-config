let
  nix-config = import ./. {};
  buildInputs = nix-config.shellBuildInputs;
  pkgs = nix-config.pkgs;
in
pkgs.mkShell {
  inherit buildInputs;
  name = "nix-config";
}
