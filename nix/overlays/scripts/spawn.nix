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
          read -ra cmd <<<"$*"
          program="''${cmd[0]}"
          name="$(basename "$program")"
          uuid="$(uuidgen)"
          exec systemd-run --user --scope --unit "run-$name-$uuid" "''${cmd[@]}"
        '';
      }
    )
    { };
}
