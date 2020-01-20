{ pkgs, ... }: {
  imports = [ ../modules/steam.nix ];
  environment.systemPackages = with pkgs; [ lutris ];
}
