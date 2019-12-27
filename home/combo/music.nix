{ pkgs, ... }: {
  imports = [
    ../modules/beets.nix
    ../../share/pkgs/bimp.nix
    ../../share/pkgs/lollypop.nix
  ];

  home.packages = with pkgs; [ bimp lollypop ];
}
