{ pkgs, ... }: {
  home-manager.users.bemeurer = { config, ... }: {
    imports = [
      ../../users/bemeurer/core
      ../../users/bemeurer/dev
      ../../users/bemeurer/modules
      ../../users/bemeurer/trusted
    ];
    programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };

  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = pkgs.fish;
  };
}
