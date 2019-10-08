{config, pkgs, lib, ...}:

{
  services.gnome-keyring = lib.mkMerge [
    {
      enable = config.isDesktop;
    }

    (lib.mkIf config.isDesktop {
      components = [ "ssh" "secrets" "pkcs11" ];
    })
  ];

  services.gpg-agent = lib.mkMerge [
    {
      enable = true;
    }

    (lib.mkIf config.isDesktop {
      enableExtraSocket = true;
      enableScDaemon = true;
      enableSshSupport = true;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry_gnome}/bin/pinentry-gnome3
      '';
    })

    (lib.mkIf (! config.isDesktop) {
      enableScDaemon = false;
      enableSshSupport = true;
    })
  ];

  services.xembed-sni-proxy.enable = config.isDesktop;
}
