{
  services.octoprint = {
    enable = true;
    plugins = plugins: with plugins; [
      displaylayerprogress
      marlingcodedocumentation
      printtimegenius
      themeify
      octoklipper
      octoprint-dashboard
    ];
    extraConfig = {
      accessControl.enabled = false;
      appearance.name = "Voron 0";
      serial = {
        port = "/run/klipper/tty";
        baudrate = "250000";
        autoconnect = true;
        disconnectOnErrors = false;
      };
      onlineCheck = {
        enabled = true;
        host = "1.1.1.1";
      };
    };
  };
}
