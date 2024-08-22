{ config, pkgs, ... }: with config.networking; {
  environment.persistence."/nix/state".directories = [
    {
      directory = "/var/lib/weechat";
      user = config.systemd.services.weechat.serviceConfig.User;
      group = config.systemd.services.weechat.serviceConfig.Group;
    }
  ];

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "weechat-attach";
      text = ''
        sudo --user=weechat tmux -S /var/lib/weechat/tmux attach
      '';
    })
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
    # for libera.chat port scanning...
    fail2ban.ignoreIP = [ "irc.libera.chat" ];
  };

  systemd.services.weechat = {
    environment.WEECHAT_HOME = "/var/lib/weechat";
    serviceConfig = {
      User = "weechat";
      Group = "weechat";
      RemainAfterExit = "yes";
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux -S /var/lib/weechat/tmux new -d -s weechat ${pkgs.weechat}/bin/weechat";
      ExecStop = "${pkgs.tmux}/bin/tmux -S /var/lib/weechat/tmux kill-session -t weechat";
    };

    wantedBy = [ "multi-user.target" ];
    wants = [ "network.target" ];
  };

  users = {
    groups.weechat = { };
    users.weechat = {
      createHome = true;
      group = "weechat";
      home = "/var/lib/weechat";
      isNormalUser = true;
    };
  };
}
