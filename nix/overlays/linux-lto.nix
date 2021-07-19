self:
let
  inherit (self) lib;

  stdenvLLVM =
    let
      llvmPin = self.buildPackages.llvmPackages_12.override {
        bootBintools = null;
        bootBintoolsNoLibc = null;
      };

      stdenv' = self.overrideCC llvmPin.stdenv llvmPin.clangUseLLVM;

      mkLLVMPlatform = platform: platform // {
        linux-kernel = platform.linux-kernel // {
          makeFlags = with llvmPin; (platform.linux-kernel.makeFlags or [ ]) ++ [
            "LLVM=1"
            "LLVM_IAS=1"
            "LD=${lld}/bin/ld.lld"
            "HOSTLD=${lld}/bin/ld.lld"
            "AR=${llvm}/bin/llvm-ar"
            "HOSTAR=${llvm}/bin/llvm-ar"
            "NM=${llvm}/bin/llvm-nm"
            "STRIP=${llvm}/bin/llvm-strip"
            "OBJCOPY=${llvm}/bin/llvm-objcopy"
            "OBJDUMP=${llvm}/bin/llvm-objdump"
            "READELF=${llvm}/bin/llvm-readelf"
            "HOSTCC=${clangUseLLVM}/bin/clang"
            "HOSTCXX=${clangUseLLVM}/bin/clang++"
          ];
        };
      };
    in
    stdenv' // {
      hostPlatform = mkLLVMPlatform stdenv'.hostPlatform;
      buildPlatform = mkLLVMPlatform stdenv'.buildPlatform;

      mkDerivation = args: stdenv'.mkDerivation (args // {
        # INFO: This line may seem useless, since we already have lld coming
        # from clangUseLLVM, but it isn't.
        # The lld provided is wrapped "llvm-binutils-wrapper" and will _NOT_
        # work. Adding lld here manually override that one, and works around the
        # issue. The real solution here is to either:
        # 1. Figure out a way to force the usage of the unwrapped bintools
        # 2. Fix our lld wrapper
        nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ llvmPin.lld ];
      });

      passthru = (stdenv'.passthru or { }) // { llvmPackages = llvmPin; };
    };

  optimizeKernel = { kernel, arch ? null }:
    let
      stdenv = stdenvLLVM;
      buildPackages = self.buildPackages // { inherit stdenv; };
    in
    kernel.override {
      inherit stdenv buildPackages;
      argsOverride.structuredExtraConfig =
        with lib.kernel; kernel.structuredExtraConfig // {
          LTO_NONE = no;
          LTO_CLANG_FULL = yes;
        } // lib.optionalAttrs (arch != null) {
          "${arch}" = yes;
        };
    };
in
_: rec {
  linux_xanmod_lto_zen3 = optimizeKernel { arch = "MZEN3"; kernel = self.linux_xanmod; };

  # INFO: Fixes for out-of-tree modules that got angry with the clang toolchain
  linuxPackages_xanmod_lto_zen3 = (self.linuxPackagesFor linux_xanmod_lto_zen3).extend (lself: lsuper: {
    ddcci-driver = lsuper.ddcci-driver.overrideAttrs (old: {
      makeFlags = (old.makeFlags or [ ]) ++ lself.kernel.makeFlags;
    });
    zfs = lsuper.zfs.overrideAttrs (old: {
      # XXX: This shouldn't be needed, but for some reason it is. I don't get
      # it.
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ lself.stdenv.passthru.llvmPackages.lld ];
      buildInputs = (old.buildInputs or [ ]) ++ [ lself.stdenv.passthru.llvmPackages.libunwind ];

      postPatch = (old.postPatch or "") + ''
        substituteInPlace config/kernel.m4 --replace \
          "make modules" \
          "make CC=${lself.stdenv.cc}/bin/cc modules"
      '';
    });
  });
}
