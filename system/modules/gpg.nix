{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pinentry-curses ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
}
