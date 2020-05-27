self: super: {
  haskellPackages = super.haskellPackages.extend (self: super: {
    x509 = super.x509.overrideAttrs (oldAttrs: { doCheck = false; });
    x509-validation = super.x509-validation.overrideAttrs (oldAttrs: { doCheck = false; });
    tls = super.tls.overrideAttrs (oldAttrs: { doCheck = false; });
  });

  xen = super.xen.overrideAttrs (oldAttrs: {
    NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -march=x86-64";
  });
}
