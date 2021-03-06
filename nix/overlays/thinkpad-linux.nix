self: super: {
  thinkpadLinux = self.linux_5_11.override {
    argsOverride = rec {
      version = "5.11.3";
      modDirVersion = version;
      src = self.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-NVjHC7OAV2PCUN87LCkiXO386ElIOv1Oy6J+Keyxy/4=";
      };
    };
  };
  thinkpadLinuxPackages = self.linuxPackagesFor self.thinkpadLinux;
}
