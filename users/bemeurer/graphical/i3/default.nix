{ pkgs, ... }: {
  imports = [
    ./i3.nix
    ./rofi.nix
  ];

  home = {
    packages = with pkgs; [
      xclip
      feh
    ];
  };
}
