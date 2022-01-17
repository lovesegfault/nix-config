final: _: {
  spawn = final.callPackage
    (
      { writeShellApplication
      , coreutils
      , systemd
      , util-linux
      }: writeShellApplication {
        name = "spawn";

        runtimeInputs = [ coreutils systemd util-linux ];

        text = ''
          [ "$#" -ge 1 ] || exit 1
          program="$0"
          name="$(basename "$program")"
          uuid="$(uuidgen)"
          set -x
          # shellcheck disable=SC2046
          exec systemd-run --user --scope --unit "run-$name-$uuid" $(eval "$*")
        '';
      }
    )
    { };
}
