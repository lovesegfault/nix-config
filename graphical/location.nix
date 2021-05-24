{
  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    appConfig.gammastep = {
      isAllowed = true;
      isSystem = true;
    };
  };
}
