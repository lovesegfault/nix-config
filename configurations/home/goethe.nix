{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    self.homeModules.music
  ];

  # Configuration deployment kind
  configKind = "home-manager";

  me = {
    username = "bemeurer";
    fullname = "Bernardo Meurer";
    email = "bernardo@meurer.org";
    uid = 22314791;
  };

  home.stateVersion = "25.11";
}
