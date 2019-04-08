{config, pkgs, lib, ...}:

{
  services.gnome-keyring = if config.isDesktop then {
    enable = true;
    components = [ "ssh" "secrets" "pkcs11" ];
  } else {
    enable = false;
  };

  services.gpg-agent = {
    enable = true;
    enableScDaemon = false;
    enableSshSupport = true;
  } // lib.optionalAttrs (config.isDesktop) {
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry_gnome}/bin/pinentry-gnome3
    '';
  };

  services.xembed-sni-proxy.enable = config.isDesktop;
}
