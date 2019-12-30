{
  nixpkgs.overlays = [
    (self: super: {
      intel-i915-drm-fix = {
        name = "intel-i915-drm-fix";
        patch = ../patches/linux-5.4-i915-drm.patch;
      };
    })
  ];
}
