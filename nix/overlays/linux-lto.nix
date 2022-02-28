final:
let
  inherit (final) lib linuxKernel;
  inherit (lib.kernel) yes no;

  applyCfg = config: kernel: kernel.override {
    argsOverride.kernelPatches = kernel.kernelPatches;
    argsOverride.structuredExtraConfig = kernel.structuredExtraConfig // config;
  };

  applyLLVM = kernel:
    let
      llvmPackages = "llvmPackages_13";
      noBintools = { bootBintools = null; bootBintoolsNoLibc = null; };
      hostLLVM = final.buildPackages.${llvmPackages}.override noBintools;
      buildLLVM = final.${llvmPackages}.override noBintools;

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
      stdenv = stdenvPlatformLLVM // {
        passthru = (stdenvPlatformLLVM.passthru or { }) // { llvmPackages = buildLLVM; };
      };
    in
    kernel.override {
      inherit stdenv;
      buildPackages = final.buildPackages // { inherit stdenv; };
      argsOverride.kernelPatches = kernel.kernelPatches;
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig;
    };

  applyLTO = kernel:
    applyCfg
      { LTO_NONE = no; LTO_CLANG_FULL = yes; }
      (applyLLVM kernel);

  applyPatches = patches: kernel: kernel.override {
    argsOverride.kernelPatches = kernel.kernelPatches ++ patches;
    argsOverride.structuredExtraConfig = kernel.structuredExtraConfig;
  };

  patches = {
    graysky = {
      name = "more-uarches-for-kernel-5.15";
      patch = final.fetchpatch {
        name = "more-uarches-for-kernel-5.15";
        url = "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.15%2B.patch";
        sha256 = "sha256-WSN+1t8Leodt7YRosuDF7eiSL5/8PYseXzxquf0LtP8=";
      };
    };
  };

  inherit (linuxKernel) packagesFor;
in
_: {
  linuxPackages_latest_lto_skylake = packagesFor
    (applyCfg
      { MSKYLAKE = yes; }
      (applyPatches
        [ patches.graysky ]
        (applyLTO
          linuxKernel.packageAliases.linux_latest.kernel)));

  linuxPackages_xanmod_lto_zen3 = packagesFor
    (applyCfg
      { MZEN3 = yes; DEBUG_INFO = lib.mkForce no; }
      (applyLTO linuxKernel.kernels.linux_xanmod));
}
