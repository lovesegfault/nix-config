self: _: {
  writeSaneShellScriptBin = self.callPackage
    (
      { stdenv
      , writeTextFile
      , lib
      , shfmt
      , shellcheck
      , runtimeShell
      }: (
        { name
        , script
        , buildInputs ? [ ]
        , checkPhase ? ""
        }: writeTextFile {
          inherit name;
          executable = true;
          destination = "/bin/${name}";
          text = ''
            #!${runtimeShell}
            set -o errexit
            set -o nounset
            set -o pipefail

            export PATH="${lib.makeBinPath buildInputs}"
          '' + script;

          checkPhase = checkPhase + ''
            ${stdenv.shell} -n $out/bin/${name}
            ${shellcheck}/bin/shellcheck $out/bin/${name}
          '';
        }
      )
    )
    { };
}
