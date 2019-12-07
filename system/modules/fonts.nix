{ pkgs, ... }: {
  fonts = {
    fontconfig = {
      defaultFonts.monospace = [ "Hack" ];
      penultimate.enable = true;
    };
    fonts = with pkgs; [ hack-font font-awesome ];
  };
}
