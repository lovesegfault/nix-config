{ pkgs, ... }: {
  imports = [
    ./rofi.nix
  ];

  home = {
    packages = with pkgs; [
      xclip
      feh
    ];
  };
}
