{ pkgs, ... }: {
  fonts = {
    fontconfig = {
      defaultFonts.monospace = [ "Hack" ];
      penultimate.enable = false;
    };
    fonts = with pkgs; [
      hack-font
      font-awesome
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
}
