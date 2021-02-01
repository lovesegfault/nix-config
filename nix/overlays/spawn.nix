self: _: {
  spawn = self.callPackage
    (
      { writeShellScriptBin
      , coreutils
      , lib
      , systemd
      , util-linux
      }: writeShellScriptBin "spawn" ''
        set -o errexit
        set -o nounset
        set -o pipefail
        set -o xtrace

        export PATH="${lib.makeBinPath [ coreutils systemd util-linux ]}:$PATH"

        [ "$#" -ge 1 ] || exit 1
        read -ra cmd <<<"$*"
        program="''${cmd[0]}"
        name="$(basename "$program")"
        uuid="$(uuidgen)"
        exec systemd-run --user --scope --unit "run-$name-$uuid" "''${cmd[@]}"
      ''
    )
    { };
}
