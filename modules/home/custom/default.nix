{ flake, ... }:
{
  imports = with flake.self.homeModules; [ custom-uid ];
}
