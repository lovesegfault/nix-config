{ pkgs, ... }: {
  home.packages = with pkgs; [ arcanist ];

  programs.zsh.shellAliases = {
    af = "arc feature";
    al = "arc land";
    ad = "arc diff";
  };
}
