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
      passthru = (stdenv'.passthru or { }) // { llvmPackages = llvmPin; };
    };

  linuxLTOFor = { kernel, extraConfig ? { } }:
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
        } // extraConfig;
    };

  linuxLTOPackagesFor = { kernel, extraConfig ? { } }:
    (self.linuxPackagesFor (linuxLTOFor { inherit kernel extraConfig; })).extend (self: super: {
      ddcci-driver = super.ddcci-driver.overrideAttrs (old: {
        makeFlags = (old.makeFlags or [ ]) ++ self.kernel.makeFlags;
      });

      zfs = super.zfs.overrideAttrs (old: {
        # XXX: This shouldn't be needed, but for some reason it is. I don't get
        # it.
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.stdenv.passthru.llvmPackages.lld ];
        buildInputs = (old.buildInputs or [ ]) ++ [ self.stdenv.passthru.llvmPackages.libunwind ];

        postPatch = (old.postPatch or "") + ''
          substituteInPlace config/kernel.m4 --replace \
            "make modules" \
            "make CC=${self.stdenv.cc}/bin/cc modules"
        '';
      });
    });
in
_: rec {
  linuxPackages_xanmod_lto_zen3 = linuxLTOPackagesFor {
    kernel = self.linux_xanmod;
    extraConfig = with lib.kernel; { MZEN3 = yes; };
  };

  linuxPackages_rpi4_lto = linuxLTOPackagesFor {
    kernel = self.linux_rpi4;
  };
}
