{ pkgs, ... }: {
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${SSH_AUTH_SOCK:-\"$HOME/.1password/agent.sock\"}";
  };

  systemd.user.services._1password = {
    Unit = {
      Description = "1Password";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
      Restart = "always";
      RestartSec = "1s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
