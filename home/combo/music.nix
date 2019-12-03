{ pkgs, ... }: {
  imports = [ ../modules/beets.nix ../../share/pkgs/bimp.nix ];

  home.packages = with pkgs; [ bimp lollypop ];
}
