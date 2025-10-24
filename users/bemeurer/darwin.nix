{ pkgs, ... }:
{
  home-manager.users.bemeurer =
    { lib, ... }:
    {
      imports = [
        ./graphical
        ./trusted
      ];
      # c.f. https://github.com/danth/stylix/issues/865
      nixpkgs.overlays = lib.mkForce null;
      programs.git.settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    home = "/Users/bemeurer";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
