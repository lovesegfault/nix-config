self: super: {
  klipper = super.klipper.overrideAttrs (_: {
    src = self.fetchFromGitHub {
      repo = "klipper";
      owner = "KevinOConnor";
      rev = "11bf83b49877f9db3f90072be73a3e078003c6a2";
      sha256 = "sha256-azZe3UmCthX9P7SEKabXujuSkpYhiUvahXu4xCM5Ohs=";
    };
  });
}
