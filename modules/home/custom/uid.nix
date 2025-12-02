{ config, lib, ... }:
with lib;
{
  options = {
    home.uid = mkOption {
      type = types.int;
      example = 1000;
      description = "The user's uid.";
    };
  };
  config = {
    assertions = [
      {
        assertion = config.home.uid != "";
        message = "UID could not be determined";
      }
    ];
  };
}
