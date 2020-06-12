{ pkgs, ... }: {
  programs.git.extraConfig.core.askpass =
    "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.gpg-agent.pinentryFlavor = "gnome3";

  home.sessionVariables."SSH_AUTH_SOCK" = "/run/user/8888/keyring/ssh";
}
