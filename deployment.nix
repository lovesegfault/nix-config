import (import ./nix).nixus ({ ... }: {
  defaults = { ... }: { nixpkgs = (import ./nix).nixpkgs; };
  nodes = {
    foucault = { ... }: {
      host = "localhost";
      configuration = ./systems/foucault.nix;
    };
  };
})
