final: prev: {
  discord = (prev.discord.overrideAttrs (old:
    let
      binaryName = "Discord";
      inherit (final) runtimeShell lib electron_20;
    in
    {
      nativeBuildInputs = old.nativeBuildInputs ++ [ final.nodePackages.asar ];
      postInstall = (old.postInstall or "") + ''
        rm $out/opt/${binaryName}/${binaryName}
        cat << EOF > $out/opt/${binaryName}/${binaryName}
        #!${runtimeShell}
        ${lib.getExe electron_20} "$out/opt/${binaryName}/resources/app.asar" "$@"
        EOF
        chmod +x $out/opt/${binaryName}/${binaryName}
      '';
    })).override { withOpenASAR = true; };
}
