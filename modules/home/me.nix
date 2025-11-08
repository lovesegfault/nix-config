{ lib, config, ... }:
{
  options.me = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for the user";
    };
    fullname = lib.mkOption {
      type = lib.types.str;
      description = "Full name of the user";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address of the user";
    };
    uid = lib.mkOption {
      type = lib.types.int;
      example = 1000;
      description = "The user's uid";
    };
  };

  config = {
    home.username = config.me.username;

    assertions = [
      {
        assertion = config.me.uid != "";
        message = "UID could not be determined";
      }
    ];
  };
}
