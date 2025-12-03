{ config, lib, ... }:
{
  options = {
    home.uid = lib.mkOption {
      type = lib.types.int;
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
