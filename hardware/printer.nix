{ pkgs, ... }: {
  environment.etc."mdns.allow".text = ''
    .local.
    .local
  '';

  programs.system-config-printer.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      brlaser
      cups-brother-mfcl2750dw
    ];
  };

  system.nssDatabases.hosts = [
    "mdns [NOTFOUND=return]"
  ];
}
