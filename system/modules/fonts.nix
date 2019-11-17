{ pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [ hack-font font-awesome ];
    fontconfig.defaultFonts.monospace = [ "Hack" ];
  };
}
