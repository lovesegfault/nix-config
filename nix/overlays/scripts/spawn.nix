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
          name="$(basename "$0")"
          uuid="$(uuidgen)"
          set -x
          exec systemd-run --user --scope --unit "run-$name-$uuid" "$@"
        '';
      }
    )
    { };
}
