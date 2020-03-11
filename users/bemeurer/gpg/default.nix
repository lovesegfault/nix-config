{ pkgs, ... }: {
  imports = [ ./gnome-keyring.nix ./gpg-agent.nix ];

  home.packages = with pkgs; [ gnome3.seahorse ];

  systemd.user.services = let
    passh = "${pkgs.passh}/bin/passh";
    sshuttle = "${pkgs.sshuttle}/bin/sshuttle";
    gopass = "${pkgs.gopass}/bin/gopass";
    sshuttleHack = pkgs.writeScriptBin "sshuttleHack" ''
      #!${pkgs.stdenv.shell}
      ${passh} -c1 \
      -P "Verification code:.*" \
      -p "$(${gopass} otp otp/google.com/bernardo@standard.ai | cut -f1 -d' ')" \
      ${sshuttle} -r bemeurer@bastion0001.us-west2.monitoring.nonstandard.ai 0/0
    '';
  in {
    sshuttle = {
      Unit = {
        Description = "sshuttle";
        PartOf = [ "default.target" ];
        Wants = [ "gnome-keyring.service" "gpg-agent.service"];
        After = [ "gnome-keyring.service" "gpg-agent.service"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${sshuttleHack}/bin/sshuttleHack";
        RestartSec = 3;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
