final: _: {
  linux-fast-headers = final.buildLinux rec {
    version = "5.16.0-rc8";
    modDirVersion = version;

    src = final.fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/mingo/tip.git/snapshot/tip-391ce485ced0e47bf8d2ce8bc32bb87887e16656.tar.gz";
      sha256 = "sha256-4X6IiQB4UUYiwqbNPHXxsdUyry1tJ/KucSo+PUo14Ic=";
    };

    kernelPatches = with final.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];

    extraMeta.branch = final.lib.versions.majorMinor version;
  };
}
