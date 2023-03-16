{ pkgs, ... }: {
  imports = [
    ../../core

    ../../graphical
  ];

  environment.variables.JAVA_HOME = "$(/usr/libexec/java_home)";

  home-manager.users.bemeurer = { config, ... }: {
    imports = [
      ../../users/bemeurer/core
      ../../users/bemeurer/dev
      ../../users/bemeurer/modules
      ../../users/bemeurer/trusted
    ];
    home = {
      sessionPath = [
        "${config.home.homeDirectory}/.toolbox/bin"
        "${config.home.homeDirectory}/.local/bin"
        "/opt/homebrew/bin"
      ];

      uid = 504;
    };
    programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };

  nix = {
    gc.automatic = true;
    settings.trusted-users = [ "root" "bemeurer" ];
  };

  users.users.bemeurer = {
    uid = 504;
    gid = 20;
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = pkgs.fish;
  };
}
