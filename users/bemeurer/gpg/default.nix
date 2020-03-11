{ pkgs, ... }: {
  imports = [ ./gnome-keyring.nix ./gpg-agent.nix ];

  home.packages = with pkgs; let
    cut = "${pkgs.coreutils}/bin/cut";
    gopass = "${pkgs.gopass}/bin/gopass";
    passh = "${pkgs.passh}/bin/passh";
    sshuttle = "${pkgs.sshuttle}/bin/sshuttle";
    sshuttleHack = pkgs.writeScriptBin "sshuttleHack" ''
      #!${pkgs.stdenv.shell}
      ${passh} -c1 \
      -P "Verification code:.*" \
      -p "$(${gopass} otp otp/google.com/bernardo@standard.ai | ${cut} -f1 -d' ')" \
      ${sshuttle} \
      -r bemeurer@bastion0001.us-west2.monitoring.nonstandard.ai 0/0 \
      --user bemeurer
    '';
  in [
    gnome3.seahorse
    sshuttleHack
  ];
}
