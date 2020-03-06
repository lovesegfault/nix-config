{ pkgs, ... }: {
  imports = [ ../modules/gnome-keyring.nix ../modules/gpg-agent.nix ];

  home.packages = with pkgs; [ gnome3.seahorse ];
}
