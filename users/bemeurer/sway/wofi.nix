{ config, pkgs, ... }: {
  home.packages = with pkgs; [ wofi ];

  # https://github.com/NixOS/nixpkgs/issues/107491
  xdg.configFile."wofi/config".text = ''
    allow_images=true
    allow_markup=true
    insensitive=true
    show=drun
    term=foot
    cache_file=${config.xdg.cacheHome}/wofi/drun
  '';
}
