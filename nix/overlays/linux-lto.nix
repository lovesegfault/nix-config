self:
let
  inherit (self) lib;

  stdenvLLVM =
    let
      hostLLVM = self.buildPackages.llvmPackages_12.override {
        bootBintools = null;
        bootBintoolsNoLibc = null;
      };
      buildLLVM = self.llvmPackages_12.override {
        bootBintools = null;
        bootBintoolsNoLibc = null;
      };

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

      stdenvClangUseLLVM = self.overrideCC hostLLVM.stdenv hostLLVM.clangUseLLVM;

      stdenvPlatformLLVM = stdenvClangUseLLVM.override (old: {
        hostPlatform = mkLLVMPlatform old.hostPlatform;
        buildPlatform = mkLLVMPlatform old.buildPlatform;
      });
    in
    stdenvPlatformLLVM // {
      passthru = (stdenvPlatformLLVM.passthru or { }) // { llvmPackages = buildLLVM; };
    };

  linuxLTOFor = { kernel, extraConfig ? { } }:
    let
      inherit (lib.kernel) yes no;
      stdenv = stdenvLLVM;
      buildPackages = self.buildPackages // { inherit stdenv; };
    in
    kernel.override {
      inherit stdenv buildPackages;
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig // {
        LTO_CLANG_FULL = yes;
        LTO_NONE = no;
      } // extraConfig;
    };

  linuxLTOPackagesFor = args: self.linuxPackagesFor (linuxLTOFor args);
in
_: rec {
  linuxPackages_xanmod_lto_zen3 = linuxLTOPackagesFor {
    kernel = self.linux_xanmod;
    extraConfig = { MZEN3 = lib.kernel.yes; };
  };
}
