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

      stdenv' = self.overrideCC hostLLVM.stdenv hostLLVM.clangUseLLVM;

      mkLLVMPlatform = platform: platform // {
        useLLVM = true;
        linux-kernel = platform.linux-kernel // {
          makeFlags = (platform.linux-kernel.makeFlags or [ ]) ++ [
            "LLVM=1"
            "LLVM_IAS=1"
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
          extraConfig = ''
            LTO_NONE n
            LTO_CLANG_FULL y
          '';
        };
      };
    in
    stdenv' // {
      hostPlatform = mkLLVMPlatform stdenv'.hostPlatform;
      buildPlatform = mkLLVMPlatform stdenv'.buildPlatform;
      passthru = (stdenv'.passthru or { }) // { llvmPackages = buildLLVM; };
    };

  linuxLTOFor = { kernel, extraConfig ? { } }:
    let
      stdenv = stdenvLLVM;
      buildPackages = self.buildPackages // { inherit stdenv; };
    in
    kernel.override {
      inherit stdenv buildPackages;
      argsOverride.structuredExtraConfig = kernel.structuredExtraConfig // extraConfig;
    };

  linuxLTOPackagesFor = { ... }@args:
    (self.linuxPackagesFor (linuxLTOFor args)).extend (
      self: super: {
        ddcci-driver = super.ddcci-driver.overrideAttrs (
          old: {
            makeFlags = (old.makeFlags or [ ]) ++ self.kernel.makeFlags;
          }
        );

        zfs = super.zfs.overrideAttrs (
          old: {
            # XXX: This shouldn't be needed, but for some reason it is. I don't get
            # it.
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.stdenv.passthru.llvmPackages.lld ];
            buildInputs = (old.buildInputs or [ ]) ++ [ self.stdenv.passthru.llvmPackages.libunwind ];

            postPatch = (old.postPatch or "") + ''
              substituteInPlace config/kernel.m4 --replace \
                "make modules" \
                "make CC=${self.stdenv.cc}/bin/cc modules"
            '';
          }
        );
      }
    );
in
_: rec {
  linuxPackages_xanmod_lto_zen3 = linuxLTOPackagesFor {
    kernel = self.linux_xanmod;
    extraConfig = { MZEN3 = lib.kernel.yes; };
  };
}
