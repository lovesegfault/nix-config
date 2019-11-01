{ config, pkgs, ... }: {

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };
    stateVersion = "19.09";
  };
}
