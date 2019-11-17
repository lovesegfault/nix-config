{
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    dnssec = "false";
    llmnr = "true";
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8 1.0.0.1 8.8.4.4 2606:4700:4700::1111 2001:4860:4860::8888 2606:4700:4700::1001 2001:4860:4860::8844
      Cache=yes
      DNSStubListener=yes
      ReadEtcHosts=yes
    '';
  };
}
