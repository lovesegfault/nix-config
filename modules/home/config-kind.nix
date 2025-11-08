{ lib, ... }:
{
  options.configKind = lib.mkOption {
    type = lib.types.enum [ "nixos" "nix-darwin" "home-manager" ];
    description = ''
      The kind of configuration deployment.

      - "nixos": Home-manager integrated with NixOS
      - "nix-darwin": Home-manager integrated with nix-darwin
      - "home-manager": Standalone home-manager

      This is used to conditionally enable features based on the deployment context.
      For example, `programs.home-manager.enable` should only be true for standalone.
    '';
    example = "home-manager";
  };
}
