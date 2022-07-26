{ pkgs, ... }: {
  home.packages = with pkgs; [
    (beets-unstable.override {
      pluginOverrides = {
        alternatives = { enable = true; propagatedBuildInputs = [ beetsPackages.alternatives ]; };
        limit = { enable = true; builtin = true; };
      };
    })
    checkart
    fixart
    mediainfo
  ];
}
