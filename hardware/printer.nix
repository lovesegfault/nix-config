{ pkgs, ... }: {
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
}
