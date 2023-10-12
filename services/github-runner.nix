{ config, ... }: {
  age.secrets.github-runner-token.file = ./github-runner.age;
  services.github-runner = {
    enable = true;
    ephemeral = true;
    replace = true;
    tokenFile = config.age.secrets.github-runner-token.path;
    url = "https://github.com/lovesegfault/nix-config";
  };
}
