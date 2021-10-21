self: super: {
  hqplayerd = super.hqplayerd.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ self.addOpenGLRunpath ];

    doInstallCheck = true;
    installCheckPhase = ''
      addOpenGLRunpath $out/bin/hqplayerd
      $out/bin/hqplayerd --version
    '';
  });
}
