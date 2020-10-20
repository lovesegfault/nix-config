{
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNS=1.1.1.1 2606:4700:4700::1111 8.8.8.8 2001:4860:4860::8844
    '';
  };
}
