{ pkgs, ... }: {
  imports = [ ./beets.nix ];

  home.packages = with pkgs; [ bimp lollypop ];
}
