_: super:
let
  optimizedFlags = [
    # Enable all safe optimizations
    "-O3"
    # Graphite specific optimizations and other optimizations that are
    # disabled at O3 but don't influence the compiler's judgement.
    "-fgraphite-identity"
    "-floop-nest-optimize"
    # This option increases compile times, but can potentially produce better
    # binaries, especially with LTO. Essentially, it allows the compiler to
    # look into called function bodies when performing alias analysis
    "-fipa-pta"
    # This allows GCC to perform devirtualization across object file
    # boundaries using LTO.
    "-fdevirtualize-at-ltrans"
    # This option omits the PLT from the executable, making calls go through
    # the GOT directly. It inhibits lazy binding, so this is not enabled by
    # default. If you use prelink, this is strictly better than lazy binding.
    "-fno-plt"
    # Safe subset of -ffast-math
    # INFO: https://gcc.gnu.org/ml/gcc/2017-09/msg00079.html
    "-fno-math-errno"
    "-fno-trapping-math"
  ];

  ltoFlags = optimizedFlags ++ [ "-flto" ];

  overrideFlags = flags: drv: drv.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + (toString flags);
    NIX_CFLAGS_LINK = (old.NIX_CFLAGS_LINK or "") + (toString flags);
  });

  optimize = names:
    super.lib.genAttrs
      names
      (name: overrideFlags ltoFlags super.${name});
in
optimize [
  "neovim-unwrapped"
  "easyeffects"
]
