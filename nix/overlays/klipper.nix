self: super: {
  klipper = super.klipper.overrideAttrs (_: {
    src = self.fetchFromGitHub {
      repo = "klipper";
      owner = "KevinOConnor";
      rev = "bdaca327072598452c14aa6716fa292446cc8086";
      sha256 = "0jvwi859r5w0ri8rp8277ffgdxx4yja786q69hm55jrpn5flyccg";
    };
  });
}
