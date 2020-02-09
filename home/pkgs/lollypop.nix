{
  nixpkgs.overlays = [
    (
      self: super: {
        lollypop = super.lollypop.overrideAttrs (
          old: {
            dontWrapGApps = false;
            preFixup = null;
          }
        );
      }
    )
  ];
}
