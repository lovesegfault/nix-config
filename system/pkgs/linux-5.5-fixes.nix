{
  nixpkgs.overlays = [
    (
      self: super: {
        nouveau-gr-fix = {
          name = "nouveau-gr-fix";
          patch = (
            builtins.fetchurl {
              url =
                "https://github.com/karolherbst/linux/commit/0a4d0a9f2ab29b4765ee819753fbbcbc2aa7da97.patch";
              sha256 = "1k4lf1cnydckjn2fqdqiizba3rzjg27xa97xjaif4ss5m7mh4ckn";
            }
          );
        };
        nouveau-pci-fix = {
          name = "nouveau-pci-fix";
          patch = (
            builtins.fetchurl {
              url =
                "https://github.com/karolherbst/linux/commit/cb048d65b71ac05158918fba2c68ca6896e51492.patch";
              sha256 = "1bh4pv6kmzq3nacvvzwzy0zlvvd3pgpamqgvpbma6rc37hgggxhn";
            }
          );
        };
        nouveau-runpm-fix = {
          name = "nouveau-runpm-fix";
          patch = (
            builtins.fetchurl {
              url =
                "https://github.com/karolherbst/linux/commit/1e6cef9e6c4d17f6d893dae3cd7d442d8574b4b5.patch";
              sha256 = "103myhwmi55f7vaxk9yqrl4diql6z32am5mzd6kvk89j9m02h528";
            }
          );
        };
      }
    )
  ];
}
