{ pkgs, ... }: {
  programs.firefox = {
    enable = (pkgs.hostPlatform == "x86_64-linux");
    package = pkgs.firefox-bin;
  };
}
