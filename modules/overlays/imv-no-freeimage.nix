final: prev: {
  imv = prev.imv.override {
    withBackends = [ "libtiff" "libjpeg" "libpng" "librsvg" "libheif" ];
    freeimage = null;
  };
}
