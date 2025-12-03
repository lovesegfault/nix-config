# agenix-rekey flake-parts integration
{ inputs, self, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem = _: {
    # Configure agenix-rekey with our NixOS configurations
    agenix-rekey.nixosConfigurations = self.nixosConfigurations;
  };
}
