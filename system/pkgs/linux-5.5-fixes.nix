{
  nixpkgs.overlays = [
    (
      self: super: {
        nouveau-gr-fix = {
          name = "nouveau-gr-fix";
          patch = (builtins.fetchurl {
            url =
              "https://github.com/karolherbst/linux/commit/0a4d0a9f2ab29b4765ee819753fbbcbc2aa7da97.patch";
            sha256 = "0ir453x9k736hqxk0wklsxyxcsh72qvlndf74wgbry3fhb8ii1xi";
          });
        };
        nouveau-pci-fix = {
          name = "nouveau-pci-fix";
          patch = (builtins.fetchurl {
            url =
              "https://github.com/karolherbst/linux/commit/cb048d65b71ac05158918fba2c68ca6896e51492.patch";
            sha256 = "1785cq3lfx20zm5ngscan31aizlncyipvnxc0vlsxv9573cdajaj";
          });
        };
      }
    )
  ];
}
