self: super: {
  haskellPackages = super.haskellPackages.extend (self: super: {
    x509 = super.x509.overrideAttrs (oldAttrs: { doCheck = false; });
    x509-validation = super.x509-validation.overrideAttrs (oldAttrs: { doCheck = false; });
    tls = super.tls.overrideAttrs (oldAttrs: { doCheck = false; });
  });
}
