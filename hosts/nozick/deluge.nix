{
  environment.persistence."/nix/state".directories = [ "/var/lib/deluge" ];

  networking.firewall = {
    allowedTCPPorts = [ 49330 ];
    allowedUDPPorts = [ 49330 ];
  };

  security.acme.certs."deluge.meurer.org" = { };

  services.deluge = {
    enable = true;
    openFilesLimit = "1048576";
    web.enable = true;
  };

  services.nginx.virtualHosts."deluge.meurer.org" = {
    useACMEHost = "deluge.meurer.org";
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8112";
      extraConfig = ''
        auth_request /validate;
        proxy_set_header X-Vouch-User $auth_resp_x_vouch_user;
        error_page 401 = @error401;
      '';
    };

    locations."@error401".extraConfig = ''
      return 302 https://vouch.meurer.org/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
    '';

    locations."/validate" = {
      proxyPass = "http://127.0.0.1:30746/validate";
      extraConfig = ''
        internal;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        auth_request_set $auth_resp_x_vouch_user $upstream_http_x_vouch_user;
        auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
        auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
        auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
      '';
    };
  };

  users.groups.media.members = [ "deluge" ];
}
