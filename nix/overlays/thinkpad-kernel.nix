self: super: {
  thinkpadKernel = self.linux_5_10.override {
    argsOverride = rec {
      version = "5.10.15";
      modDirVersion = version;
      src = self.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-2FKHvPHVHE0KMjgKwKWytIezIQWKaSNhfxYT+9EObgE=";
      };
    };
  };
  thinkpadKernelPackages = self.linuxPackagesFor self.thinkpadKernel;
}
