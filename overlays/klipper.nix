self: super: {
  klipper = super.klipper.overrideAttrs (_: {
    src = self.fetchFromGitHub {
      repo = "klipper";
      owner = "KevinOConnor";
      rev = "e0842e0e03b29dce260bf9e519d08f48f7e5ace7";
      sha256 = "0fkglg24xh8hlrygvanvh5q56fz1ay06kqs1lq7782dsl9kd1vfx";
    };
  });
}
