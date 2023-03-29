final: prev: {
  discord = if final.stdenv.hostPlatform.isMacOS then prev.discord else final.discord_new_electron;
  discord_new_electron = (prev.discord.overrideAttrs (old:
    let
      binaryName = "Discord";
      inherit (final) runtimeShell lib electron;
    in
    {
      nativeBuildInputs = old.nativeBuildInputs ++ [ final.nodePackages.asar ];
      postInstall = (old.postInstall or "") + ''
        rm $out/opt/${binaryName}/${binaryName}
        cat << EOF > $out/opt/${binaryName}/${binaryName}
        #!${runtimeShell}
        ${lib.getExe electron} "$out/opt/${binaryName}/resources/app.asar" "$@"
        EOF
        chmod +x $out/opt/${binaryName}/${binaryName}
      '';
    })).override { withOpenASAR = true; };
}
