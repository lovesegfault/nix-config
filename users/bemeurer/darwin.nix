{ pkgs, ... }: {
  home-manager.users.bemeurer = {
    imports = [
      ./graphical
      ./trusted
    ];
    programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };

  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
