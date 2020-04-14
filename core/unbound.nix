{
  networking.networkmanager.dns = "unbound";

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    forwardAddresses = [ "1.1.1.1" "2606:4700:4700::1111" "8.8.8.8" "2001:4860:4860::8844" ];
    extraConfig = ''
      # This is part of the server clause
      infra-cache-slabs: 16
      key-cache-slabs: 16
      msg-cache-size: 50m
      msg-cache-slabs: 16
      num-threads: 12
      outgoing-range: 950
      ratelimit-labs: 16
      rrset-cache-size: 100m
      rrset-cache-slabs: 16
      so-reuseport: yes

    remote-control:
      # Enable remote control with unbound-control(8) here.
      # set up the keys and certificates with unbound-control-setup.
      control-enable: yes
      # what interfaces are listened to for remote control.
      # give 0.0.0.0 and ::0 to listen to all interfaces.
      control-interface: 127.0.0.1
      # port number for remote control operations.
      control-port: 8953
      # unbound server key file.
      server-key-file: "/var/lib/unbound/unbound_server.key"
      # unbound server certificate file.
      server-cert-file: "/var/lib/unbound/unbound_server.pem"
      # unbound-control key file.
      control-key-file: "/var/lib/unbound/unbound_control.key"
      # unbound-control certificate file.
      control-cert-file: "/var/lib/unbound/unbound_control.pem"
    '';
  };
}
