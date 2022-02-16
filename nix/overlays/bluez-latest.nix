final: _: {
  bluez_5_63 = (final.bluez5.overrideAttrs (_: rec {
    version = "5.63";
    src = final.fetchurl {
      url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
      sha256 = "sha256-k0nhHoFguz1yCDXScSUNinQk02kPUonm22/gfMZsbXY=";
    };
  })).override { withExperimental = true; };
}
