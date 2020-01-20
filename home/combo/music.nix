{ pkgs, ... }: {
  imports = [ ../modules/beets.nix ../pkgs/bimp.nix ../pkgs/lollypop.nix ];

  home.packages = with pkgs; [ bimp lollypop ];
}
