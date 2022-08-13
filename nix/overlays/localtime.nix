_: prev: {
  localtime = prev.localtime.overrideAttrs (_: {
    buildPhase = ''
      runHook preBuild
      make PREFIX="$out"
      runHook postBuild
    '';

    doCheck = false;
  });
}
