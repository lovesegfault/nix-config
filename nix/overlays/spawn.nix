self: _: {
  spawn = self.callPackage
    (
      { writeSaneShellScriptBin
      , coreutils
      , systemd
      , util-linux
      }: writeSaneShellScriptBin {
        name = "spawn";

        buildInputs = [ coreutils systemd util-linux ];

        src = ''
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
