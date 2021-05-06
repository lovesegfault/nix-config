{ pkgs, ... }: {
  programs.firefox = {
    enable = (pkgs.hostPlatform.system == "x86_64-linux");
    package = pkgs.firefox-bin;
  };
}
