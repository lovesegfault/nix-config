self: super: {
  llvmPackages_rocm = super.llvmPackages_rocm // {
    compiler-rt = super.llvmPackages_rocm.compiler-rt.overrideAttrs (_: {
      patches = [
        (self.path + "/pkgs/development/compilers/llvm/rocm/compiler-rt/compiler-rt-codesign.patch")
        (self.fetchpatch {
          name = "libsanitizer-no-cyclades-rocm.patch";
          url = "https://gist.github.com/lovesegfault/b255dcf2fa4e202411a6a04b61e6cc04/raw";
          sha256 = "sha256-PMMSLr2zHuNDn1OWqumqHwB74ktJSHxhJWkqEKB7Z64=";
          stripLen = 1;
        })
      ];
    });
  };
}
