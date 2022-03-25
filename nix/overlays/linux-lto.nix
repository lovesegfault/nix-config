final:
let
  inherit (final) lib linuxKernel;
  inherit (lib.kernel) yes no;

  cfg = config: kernel: kernel.override {
    argsOverride.kernelPatches = kernel.kernelPatches;
    argsOverride.structuredExtraConfig = kernel.structuredExtraConfig // config;
  };

  llvm = kernel:
    let
      llvmPackages = "llvmPackages_13";
      noBintools = { bootBintools = null; bootBintoolsNoLibc = null; };
      hostLLVM = final.pkgsBuildHost.${llvmPackages}.override noBintools;
      buildLLVM = final.pkgsBuildBuild.${llvmPackages}.override noBintools;

      mkLLVMPlatform = platform: platform // {
        useLLVM = true;
        linux-kernel = platform.linux-kernel // {
          makeFlags = (platform.linux-kernel.makeFlags or [ ]) ++ [
            "LLVM=1"
            "LLVM_IAS=1"
            "CC=${buildLLVM.clangUseLLVM}/bin/clang"
            "LD=${buildLLVM.lld}/bin/ld.lld"
            "HOSTLD=${hostLLVM.lld}/bin/ld.lld"
            "AR=${buildLLVM.llvm}/bin/llvm-ar"
            "HOSTAR=${hostLLVM.llvm}/bin/llvm-ar"
            "NM=${buildLLVM.llvm}/bin/llvm-nm"
            "STRIP=${buildLLVM.llvm}/bin/llvm-strip"
            "OBJCOPY=${buildLLVM.llvm}/bin/llvm-objcopy"
            "OBJDUMP=${buildLLVM.llvm}/bin/llvm-objdump"
            "READELF=${buildLLVM.llvm}/bin/llvm-readelf"
            "HOSTCC=${hostLLVM.clangUseLLVM}/bin/clang"
            "HOSTCXX=${hostLLVM.clangUseLLVM}/bin/clang++"
          ];
        };
      };
      stdenvClangUseLLVM = final.overrideCC hostLLVM.stdenv hostLLVM.clangUseLLVM;
      stdenvPlatformLLVM = stdenvClangUseLLVM.override (old: {
        hostPlatform = mkLLVMPlatform old.hostPlatform;
        buildPlatform = mkLLVMPlatform old.buildPlatform;
      });
      stdenv = stdenvPlatformLLVM;
    in
    kernel.override {
      inherit stdenv;
      buildPackages = final.buildPackages // { inherit stdenv; };
      argsOverride.kernelPatches = kernel.kernelPatches;
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig;
    };

  fullLTO = kernel:
    cfg
      { LTO_NONE = no; LTO_CLANG_FULL = yes; }
      (llvm kernel);

  patch = patches: kernel: kernel.override {
    argsOverride.kernelPatches = kernel.kernelPatches ++ patches;
    argsOverride.structuredExtraConfig = kernel.structuredExtraConfig;
  };

  patches = {
    graysky = {
      name = "more-uarches-for-kernel-5.15";
      patch = final.fetchpatch {
        name = "more-uarches-for-kernel-5.15";
        url = "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/9c9c7e817dd2718566ec95f7742b162ab125316f/more-uarches-for-kernel-5.15%2B.patch";
        sha256 = "sha256-WSN+1t8Leodt7YRosuDF7eiSL5/8PYseXzxquf0LtP8=";
      };
    };
  };

  inherit (linuxKernel) kernels packagesFor;
in
_: {
  linuxPackages_latest_lto_skylake = packagesFor
    (cfg
      { MSKYLAKE = yes; }
      (patch
        [ patches.graysky ]
        (fullLTO kernels.linux_5_16)));

  linuxPackages_xanmod_lto_zen3 = packagesFor
    (cfg
      { MZEN3 = yes; DEBUG_INFO = lib.mkForce no; }
      (fullLTO kernels.linux_xanmod));
}
