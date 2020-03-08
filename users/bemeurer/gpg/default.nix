{ pkgs, ... }: {
  imports = [ ./gnome-keyring.nix ./gpg-agent.nix ];

  home.packages = with pkgs; [ gnome3.seahorse ];
}
