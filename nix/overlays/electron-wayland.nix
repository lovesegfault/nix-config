self:
let
  enableWayland = drv: bin: drv.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/${bin} \
        --add-flags "--enable-features=UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland"
    '';
  });
in
super:
{
  slack = enableWayland super.slack "slack";
  signal-desktop = enableWayland super.signal-desktop "signal-desktop";
  element-desktop = enableWayland super.element-desktop "element-desktop";
}
