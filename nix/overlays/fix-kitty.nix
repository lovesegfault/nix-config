final: prev: {
  kitty = prev.kitty.overrideAttrs (old: {
    preBuild = (old.preBuild or "") + ''
      # Add the font by hand because fontconfig does not finds it in darwin
      mkdir ./fonts/
      cp "${(final.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})}/share/fonts/truetype/NerdFonts/SymbolsNerdFontMono-Regular.ttf" ./fonts/
    '';
  });
}
