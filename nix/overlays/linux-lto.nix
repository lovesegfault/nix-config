/*
  # WARNING:
  This place is a message... and part of a system of messages... pay attention to
  it!

  Sending this message was important to us. We considered ourselves to be a
  powerful culture.

  This place is not a place of honor... no highly esteemed deed is commemorated
  here... nothing valued is here.

  What is here was dangerous and repulsive to us. This message is a warning about
  danger.

  The danger is in a particular location... it increases towards a center... the
  center of danger is here... of a particular size and shape, and below us.

  The danger is still present, in your time, as it was in ours.

  The danger is to the body, and it can kill.

  The form of the danger is an emanation of energy.

  The danger is unleashed only if you substantially disturb this place physically.
  This place is best shunned and left uninhabited.
*/
# WARNING: There is some spooky non-determinism in the build, sometimes it will
# just fail to link for no apparent reason, and then building again will
# succeed.  Using lld to build the kernel is in a very early stage. Read the
# message above again.
self:
let
  llvmPin = "llvmPackages_12";

  # We start by creating a new stdenv that is appropriate for compiling the
  # kernel with clang and lld. This means, primarly, that we must:
  # 1. Override the CC to be clang, LD to be lld
  # 2. Ensure the correct makeflags are set for the kernel to use LLVM
  stdenvLLVM =
    let
      # this is clang with lld instead of binutils' bfd.
      clangLLVM = (self.buildPackages."${llvmPin}".override {
        bootBintools = null;
        bootBintoolsNoLibc = null;
      }).clangUseLLVM;

      # and this is the stdenv with that toolchain instead of gcc.
      stdenv' = self.overrideCC self.stdenv clangLLVM;
    in
    stdenv' // rec {
      mkDerivation = args: stdenv'.mkDerivation (args // {
        # XXX: This _HAS_ to be here. I do not know why. If you remove it things
        # explode. It makes absolutely no sense, but I don't make the rules.
        nativeBuildInputs = (args.nativeBuildInputs or [ ])
        ++ (with self.buildPackages."${llvmPin}"; [
          lld
        ]);
      });
      # set everything the kernel needs to be built with the LLVM tools
      hostPlatform = stdenv'.hostPlatform // {
        linux-kernel = stdenv'.hostPlatform.linux-kernel // rec {
          baseConfig = "${toString makeFlags} defconfig";
          makeFlags = (stdenv'.hostPlatform.linux-kernel.makeFlags or [ ]) ++ [
            "LLVM=1"
            "LLVM_IAS=1"
            "LD=ld.lld"
            "AR=llvm-ar"
            "NM=llvm-nm"
            "STRIP=llvm-strip"
            "OBJCOPY=llvm-objcopy"
            "OBJDUMP=llvm-objdump"
            "READELF=llvm-readelf"
            "HOSTCC=clang"
            "HOSTCXX=clang++"
            "HOSTAR=llvm-ar"
            "HOSTLD=ld.lld"
          ];
        };
      };
    };

  # INFO: el biggus hackus no.1
  # this lets us pre-patch the kernel source so that we don't have to fiddle
  # with kernelPatches in the overrideAttrs that follow. It also allows us to
  # make changes to the source before any other patches have had a chance of
  # being applied.
  fixKernelSrc = k: self.applyPatches {
    inherit (k) src;
    patches = [
      # INFO: https://github.com/NixOS/nixpkgs/pull/129879
      (self.writeText "unmangle-build-id.patch" ''
        diff --git a/Makefile b/Makefile
        index 5b982a027..97e52543d 100644
        --- a/Makefile
        +++ b/Makefile
        @@ -1032,8 +1032,8 @@ KBUILD_CPPFLAGS += $(KCPPFLAGS)
         KBUILD_AFLAGS   += $(KAFLAGS)
         KBUILD_CFLAGS   += $(KCFLAGS)

        -KBUILD_LDFLAGS_MODULE += --build-id=sha1
        -LDFLAGS_vmlinux += --build-id=sha1
        +KBUILD_LDFLAGS_MODULE += --build-id
        +LDFLAGS_vmlinux += --build-id

         ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
         LDFLAGS_vmlinux  += $(call ld-option, -X,)
      '')

      # INFO: Getting rid of this patch will require us to extend the nixpkgs
      # kernel generation mechanism to support custom flags in
      # generate-config.pl
      # The issue is that even when you set makeFlags for the kernel, they are
      # not used during config generation, which causes the configuration step
      # to be done with LLVM disabled, at which point it fails in the assembler
      # version check.
      # Worse yet, the failure there is mostly silent, as the configuration
      # continues, but you end up with a kernel with none of the things you
      # wanted enabled, and that probably doesn't even boot.
      # This patch force enables LLVM in the makefile, making it impossible for
      # any other toolchain to be used.
      # XXX: DONT LET NIXPKGS-FMT TOUCH THIS FILE
      # XXX: THE TRAILING WHITESPACE IS LOAD BEARING
      (self.writeText "force-llvm.patch" ''
        diff --git a/Makefile b/Makefile
        index 5b982a027d00..cc42c9342bfc 100644
        --- a/Makefile
        +++ b/Makefile
        @@ -414,7 +414,7 @@ HOST_LFS_CFLAGS := $(shell getconf LFS_CFLAGS 2>/dev/null)
         HOST_LFS_LDFLAGS := $(shell getconf LFS_LDFLAGS 2>/dev/null)
         HOST_LFS_LIBS := $(shell getconf LFS_LIBS 2>/dev/null)
         
        -ifneq ($(LLVM),)
        +ifeq (1,1)
         HOSTCC	= clang
         HOSTCXX	= clang++
         else
        @@ -433,7 +433,7 @@ KBUILD_HOSTLDLIBS   := $(HOST_LFS_LIBS) $(HOSTLDLIBS)
         
         # Make variables (CC, etc...)
         CPP		= $(CC) -E
        -ifneq ($(LLVM),)
        +ifeq (1,1)
         CC		= clang
         LD		= ld.lld
         AR		= llvm-ar
        @@ -577,7 +577,7 @@ ifneq ($(findstring clang,$(CC_VERSION_TEXT)),)
         ifneq ($(CROSS_COMPILE),)
         CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
         endif
        -ifeq ($(LLVM_IAS),1)
        +ifeq (1,1)
         CLANG_FLAGS	+= -integrated-as
         else
         CLANG_FLAGS	+= -no-integrated-as
        @@ -846,7 +846,7 @@ else
         DEBUG_CFLAGS	+= -g
         endif
         
        -ifneq ($(LLVM_IAS),1)
        +ifneq (1,1)
         KBUILD_AFLAGS	+= -Wa,-gdwarf-2
         endif
         
      '')
    ];
  };

  # INFO: This will further tune the kernel, may not work for all sources.
  forceOptimize =
    { arch, kernel }:
    kernel.override {
      argsOverride = {
        structuredExtraConfig = with self.lib.kernel; {
          "${arch}" = yes;

          # Preemptive Full Tickless Kernel at 500Hz
          PREEMPT_VOLUNTARY = self.lib.mkForce no;
          PREEMPT = self.lib.mkForce yes;
          NO_HZ_FULL = yes;
          HZ_500 = yes;

          # Google's Multigenerational LRU Framework
          LRU_GEN = yes;
          LRU_GEN_ENABLED = yes;

          # Google's BBRv2 TCP congestion Control
          TCP_CONG_BBR2 = yes;
          DEFAULT_BBR2 = yes;

          # FQ-PIE Packet Scheduling
          NET_SCH_DEFAULT = yes;
          DEFAULT_FQ_PIE = yes;

          # Graysky's additional CPU optimizations
          CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

          # Android Ashmem and Binder IPC Driver as module for Anbox
          ASHMEM = module;
          ANDROID = yes;
          ANDROID_BINDER_IPC = module;
          ANDROID_BINDERFS = module;
          ANDROID_BINDER_DEVICES = freeform "binder,hwbinder,vndbinder";
        };
      };
    };

  # This take any kernel package and treats its source so that it's LLVM-locked,
  # as well as replaces its stdenv with out LLVM one.
  forceLLVM = k: k.overrideAttrs (_: {
    stdenv = stdenvLLVM;
    src = fixKernelSrc k;
  });

  # INFO: el biggus hackus no.2
  # For whatever reason our tooling around Kconfig makes it literally impossible
  # to set the LTO options. I do not understand why yet.
  # This hack takes a kernel's configfile, and creates a new one with LTO
  # manually enabled.
  # Read the message at the top again if you just threw up a little.
  # INFO: You can replace FULL with THIN here if you want thin LTO.
  configLTO = k: self.runCommandNoCC "configLTO" { } ''
    cp ${k.configfile} $out
    sed -i $out -e "s|CONFIG_LTO_NONE=y|CONFIG_LTO_NONE=n\
    \nCONFIG_LTO_CLANG_FULL=y|"
  '';

  # Finally, we can construct an LTO'd kernel.
  # Here we create an LLVM'd kernel derivation (cheap since we don't ever build
  # it) solely so we can generate a kernel configuration for it, which we then
  # steal and patch to enable LTO.
  # We use that config to manually create a new kernel package that, god
  # willing, will be fully LTO'd. Again, message at the top.
  makeLTO =
    { arch ? null, kernel }:
    let
      k = kernel;
      k' =
        if (arch == null)
        then forceLLVM k
        else forceOptimize { inherit arch; kernel = forceLLVM k; };
      configfile = configLTO k';
      kLTO =
        self.linuxManualConfig {
          stdenv = stdenvLLVM;
          inherit (self) lib;
          inherit (k) version modDirVersion;
          inherit (k') src config;
          inherit configfile;

          extraMeta = {
            inherit (k.meta) branch broken;
          };
        };
    in
    kLTO.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.python3 ];
      postPatch = (old.postPatch or "") + ''
        patchShebangs scripts/jobserver-exec
      '';

      passthru = (old.passthru or { }) // {
        inherit (k.passthru) features;
      };
    });
in
_: {
  # See you next week for the next episode of "Will it boot?!"
  linux_xanmod_lto_zen3 = makeLTO { arch = "MZEN3"; kernel = self.linux_xanmod; };

  # INFO: Fixes for out-of-tree modules that got angry with the clang toolchain
  linuxPackages_xanmod_lto_zen3 = (self.linuxPackagesFor self.linux_xanmod_lto_zen3).extend (lself: lsuper: {
    ddcci-driver = lsuper.ddcci-driver.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.which ];
      makeFlags = (old.makeFlags or [ ]) ++ [
        "CC=${lself.stdenv.cc}/bin/cc"
        "LD=${lself.stdenv.cc}/bin/ld"
      ];
    });
    zfs = lsuper.zfs.overrideAttrs (old: {
      # XXX: The plot only thickes, if we already add lld unconditionally to the
      # stdenv, then why does this fail without lld being explicitly added
      # here?!
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ (with self."${llvmPin}"; [ llvm lld ]);
      buildInputs = (old.buildInputs or [ ])
        ++ (with self."${llvmPin}"; [ libunwind ]);
      postPatch = (old.postPatch or "") + ''
        substituteInPlace config/kernel.m4 --replace \
          "make modules" \
          "make CC=${lself.stdenv.cc}/bin/cc modules"
      '';
    });
  });
}
