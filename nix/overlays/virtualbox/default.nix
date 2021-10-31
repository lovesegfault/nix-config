final: _:
with final.lib;
{
  virtualbox = final.libsForQt514.callPackage ./virtualbox.nix {
    stdenv = final.stdenv_32bit;
    inherit (final.gnome2) libIDL;
    # jdk = final.openjdk8;
  };

  virtualboxExtpack = final.callPackage ./extpack.nix { };

  virtualboxHardened = lowPrio (final.virtualbox.override {
    enableHardening = true;
  });

  virtualboxHeadless = lowPrio (final.virtualbox.override {
    enableHardening = true;
    headless = true;
  });

  virtualboxWithExtpack = final.virtualbox.override {
    extensionPack = final.virtualboxExtpack;
  };
}
