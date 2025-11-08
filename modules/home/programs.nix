{ pkgs, ... }:
{
  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = [ "--disable-up-arrow" ];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
    gpg.enable = true;
    zoxide.enable = true;
  };
}
