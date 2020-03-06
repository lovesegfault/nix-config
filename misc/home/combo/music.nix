{ pkgs, ... }: {
  imports = [ ../modules/beets.nix ../pkgs/bimp.nix ];

  home.packages = with pkgs; [ bimp lollypop ];
}
