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
          pname="$(basename "$1")"
          uuid="$(uuidgen)"
          exec systemd-run --user --scope --unit "spawn-$pname-$uuid" "$@"
        '';
      }
    )
    { };
}
