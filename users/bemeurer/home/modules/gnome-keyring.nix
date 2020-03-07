{ pkgs, ... }: {
  programs.git.extraConfig.core.askpass =
    "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.sessionVariables."SSH_AUTH_SOCK" = "/run/user/1000/keyring/ssh";
}
