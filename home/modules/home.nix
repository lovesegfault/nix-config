{ config, pkgs, ... }: {

  home = {
    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };
    stateVersion = "19.09";
  };
}
