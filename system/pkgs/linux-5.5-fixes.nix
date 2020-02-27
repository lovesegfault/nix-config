{
  nixpkgs.overlays = [
    (
      self: super: {
        nouveau-gr-fix = {
          name = "nouveau-gr-fix";
          patch = (builtins.fetchurl {
            url = "https://github.com/karolherbst/linux/commit/db333d73683578b5176a6f544750c62cbb5a57e0.patch";
            sha256 = "1rrsvagvk5pc96ig6pg1b30w2fswj8vm2fhm53wqb52ksdrh8a2s";
          });
        };
        nouveau-pci-fix = {
          name = "nouveau-pci-fix";
          patch = (builtins.fetchurl {
            url = "https://github.com/karolherbst/linux/commit/b4c8166b1a5da40041ce899e143f30c54a79e9fe.patch";
            sha256 = "16pxih1wqvps6f6ilrrd3k8iw3gcyjpskzwwk73y3ayamjnrwhv6";
          });
        };
      }
    )
  ];
}
