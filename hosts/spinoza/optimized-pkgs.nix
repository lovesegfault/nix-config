let
  optimizedOverlayForHost = { hostCFlags ? [ ], hostRustflags ? [ ] }:
    final: prev:
      let
        inherit (prev) lib;

        appendFlags = new: old:
          with builtins;
          if isString old then lib.concatStringsSep " " ([ old ] ++ new)
          else if isList old then lib.concatStringsSep " " (old ++ new)
          else (lib.concatStringsSep " " new);

        applyFlags = { cflags ? null, rustflags ? null }: pkg:
          pkg.overrideAttrs (old:
            (lib.optionalAttrs (cflags != null) {
              NIX_CFLAGS_COMPILE = appendFlags cflags (old.NIX_CFLAGS_COMPILE or null);
              NIX_CFLAGS_LINK = appendFlags cflags (old.NIX_CFLAGS_LINK or null);
            })
            // (lib.optionalAttrs (rustflags != null) {
              CARGO_BUILD_RUSTFLAGS = appendFlags rustflags (old.CARGO_BUILD_RUSTFLAGS or null);
            })
          );

        applyHost = applyFlags { cflags = hostCFlags; rustflags = hostRustflags; };
        # FIXME: Broken, idk why
        # applyLTO = applyFlags { cflags = [ "-flto=auto" "-fuse-linker-plugin" ]; };
        applyGraphite = applyFlags { cflags = [ "-fgraphite-identity" "-floop-nest-optimize" ]; };

      in
      {
        alacritty = applyHost prev.alacritty;

        foot = applyGraphite (applyHost prev.foot);
        neovim-unwrapped = applyGraphite (applyHost prev.neovim-unwrapped);
        sway-unwrapped = applyGraphite (applyHost prev.sway-unwrapped);
        waybar = applyGraphite (applyHost prev.waybar);
        wireplumber = applyGraphite (applyHost prev.wireplumber);
        wlroots = applyGraphite (applyHost prev.wlroots);

        pipewire-optimized = applyGraphite (applyHost final.pipewire);
        systemd-optimized = applyGraphite (applyHost final.systemd);
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
