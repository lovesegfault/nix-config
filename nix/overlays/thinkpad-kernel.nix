self: super: {
  thinkpadKernel = self.linux_5_10.override {
    argsOverride = rec {
      version = "5.10.16";
      modDirVersion = version;
      src = self.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-U2/j6ic7/McrNXHTs6f/ClvNwWBo79IuQsT50DwgCjc=";
      };
    };
  };
  thinkpadKernelPackages = self.linuxPackagesFor self.thinkpadKernel;
}
