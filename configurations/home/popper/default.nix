# Home-manager configuration for popper
{ flake, ... }:
let
  inherit (flake) self;
in
{
  imports = [ self.homeModules.profiles-argocd ];
}
