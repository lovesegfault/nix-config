let
  optimizedOverlayForHost = { hostCFlags ? [ ], hostRustflags ? [ ] }:
    final: prev:
      let
        inherit (prev.lib) concatStringsSep optionalAttrs pipe;

        appendFlags = new: old:
          with builtins;
          if isString old then concatStringsSep " " ([ old ] ++ new)
          else if isList old then concatStringsSep " " (old ++ new)
          else (concatStringsSep " " new);

        applyFlags = { cflags ? null, rustflags ? null }: pkg:
          pkg.overrideAttrs (old:
            (optionalAttrs (cflags != null) {
              NIX_CFLAGS_COMPILE = appendFlags cflags (old.NIX_CFLAGS_COMPILE or null);
              NIX_CFLAGS_LINK = appendFlags cflags (old.NIX_CFLAGS_LINK or null);
            })
            // (optionalAttrs (rustflags != null) {
              CARGO_BUILD_RUSTFLAGS = appendFlags rustflags (old.CARGO_BUILD_RUSTFLAGS or null);
            })
          );

        applyHost = applyFlags { cflags = hostCFlags; rustflags = hostRustflags; };
        applyGraphite = applyFlags { cflags = [ "-fgraphite-identity" "-floop-nest-optimize" ]; };
        # FIXME: Broken: https://github.com/NixOS/nixpkgs/pull/188544
        # applyLTO = applyFlags { cflags = [ "-flto=auto" "-fuse-linker-plugin" ]; };
      in
      {
        alacritty = applyHost prev.alacritty;

        foot = pipe prev.foot [ applyHost applyGraphite ];
        neovim-unwrapped = pipe prev.neovim-unwrapped [ applyHost applyGraphite ];
        sway-unwrapped = pipe prev.sway-unwrapped [ applyHost applyGraphite ];
        waybar = pipe prev.waybar [ applyHost applyGraphite ];
        wireplumber = pipe prev.wireplumber [ applyHost applyGraphite ];
        wlroots = pipe prev.wlroots [ applyHost applyGraphite ];

        pipewire-optimized = pipe final.pipewire [ applyHost applyGraphite ];
        systemd-optimized = pipe final.systemd [ applyHost applyGraphite ];
      };
in
optimizedOverlayForHost {
  hostRustflags = [ "-Ctarget-cpu=znver3" ];
  hostCFlags = [
    "-march=znver3"
    # XXX: I don't trust shadow stack support yet. Wait for Linux 6.4+
    # "-mshstk"
    "--param=l1-cache-line-size=64"
    "--param=l1-cache-size=32"
    "--param=l2-cache-size=512"
  ];
}
