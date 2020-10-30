self: super: {
  klipper = super.klipper.overrideAttrs (_: {
    src = self.fetchFromGitHub {
      repo = "klipper";
      owner = "KevinOConnor";
      rev = "79877acb14c01720130c469a25e86f0d06c539f3";
      sha256 = "0fkglg24xh8hlrygvanvh5q56fz1ay06kqs1lq7782dsl9kd1vfx";
    };
  });
}
