import (import ./nix).nixus ({ ... }: {
  defaults = { ... }: { nixpkgs = (import ./nix).nixpkgs; };
  nodes = {
    foucault = { ... }: {
      host = "localhost";
      configuration = ./systems/foucault.nix;
    };
    cantor = { ... }: {
      host = "10.0.5.217";
      configuration = ./systems/cantor.nix;
    };
  };
})
