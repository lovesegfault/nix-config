self: super: {
  thinkpadLinux = self.linux_5_11.override {
    argsOverride = rec {
      version = "5.11.5";
      modDirVersion = version;
      src = self.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-IgjkYXtjqIk3P7P4XvVqc666g8EXUWv8yS70Swi9PWs=";
      };
    };
  };
  thinkpadLinuxPackages = self.linuxPackagesFor self.thinkpadLinux;
}
