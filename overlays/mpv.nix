self: super: {
  mpv = super.mpv.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "mpv";
      owner = "mpv-player";
      rev = "c9742413ac5eeabfdd46503f67b7393c9bd99f49";
      sha256 = "0000000000000000000000000000000000000000000000000000000000000000";
    };
  });
}
