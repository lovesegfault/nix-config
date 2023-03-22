final: prev: {
  discord = (prev.discord.overrideAttrs (old:
    let
      binaryName = "Discord";
      inherit (final) runtimeShell lib electron;
    in
    {
      nativeBuildInputs = old.nativeBuildInputs ++ [ final.nodePackages.asar ];
      postInstall = (old.postInstall or "") + (lib.optionalString final.stdenv.hostPlatform.isLinux ''
        rm $out/opt/${binaryName}/${binaryName}
        cat << EOF > $out/opt/${binaryName}/${binaryName}
        #!${runtimeShell}
        ${lib.getExe electron} "$out/opt/${binaryName}/resources/app.asar" "$@"
        EOF
        chmod +x $out/opt/${binaryName}/${binaryName}
      '');
    })).override { withOpenASAR = true; };
}
