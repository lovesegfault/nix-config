{ config, pkgs, ... }: with config.networking; {
  environment.persistence."/nix/state".directories = [
    {
      directory = config.services.weechat.root;
      user = config.systemd.services.weechat.serviceConfig.User;
      group = config.systemd.services.weechat.serviceConfig.Group;
    }
  ];

  security.acme.certs."irc.${hostName}.meurer.org" = { };

  services = {
    nginx.virtualHosts."irc.${hostName}.meurer.org" = {
      useACMEHost = "irc.${hostName}.meurer.org";
      forceSSL = true;
      kTLS = true;
      locations."^~ /weechat" = {
        proxyPass = "http://127.0.0.1:9001";
        proxyWebsockets = true;
      };
      locations."/" = {
        root = pkgs.glowing-bear;
      };
    };
    weechat.enable = true;
    # for libera.chat port scanning...
    fail2ban.ignoreIP = [ "irc.libera.chat" ];
  };

  programs.screen = {
    enable = true;
    screenrc = ''
      multiuser on
      acladd normal_user
      truecolor on
    '';
  };

}
