{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    displayManager.lightdm = {
      greeters.gtk.cursorTheme.size = 64;
      greeters.gtk.extraConfig = "xft-dpi=200";
    };
  };
}
