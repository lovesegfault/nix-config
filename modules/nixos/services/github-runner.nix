{ config, pkgs, ... }:
{
  age.secrets.github-runner-token.rekeyFile = ../../../secrets/github-runner.age;
  services.github-runners.${config.networking.hostName} = {
    enable = true;
    ephemeral = true;
    replace = true;
    tokenFile = config.age.secrets.github-runner-token.path;
    url = "https://github.com/lovesegfault/nix-config";
    extraLabels = [ pkgs.stdenv.hostPlatform.system ];
    extraPackages = with pkgs; [ cachix ];
  };
}
