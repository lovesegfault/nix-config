final: prev: {
  nushell = prev.nushell.overrideAttrs (_: {
    doCheck = !final.stdenv.hostPlatform.isDarwin;
  });
}
