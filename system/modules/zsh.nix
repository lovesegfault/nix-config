{ pkgs, ... }: {
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  users.users.bemeurer.shell = pkgs.zsh;
}
