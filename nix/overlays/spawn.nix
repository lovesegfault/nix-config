self: _: {
  spawn = self.writeScriptBin "spawn" ''
    #!${self.stdenv.shell}
    set -o errexit
    set -o nounset
    set -o pipefail
    set -o xtrace

    [ "$#" -ge 1 ] || exit 1
    read -ra cmd <<<"$*"
    program="''${cmd[0]}"
    name="$(${self.coreutils}/bin/basename "$program")"
    uuid="$(${self.utillinux}/bin/uuidgen)"
    exec ${self.systemd}/bin/systemd-run --user --scope --unit "run-$name-$uuid" "''${cmd[@]}"
  '';
}
