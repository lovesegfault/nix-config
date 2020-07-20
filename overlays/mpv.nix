self: super: {
  mpv = super.mpv.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "mpv";
      owner = "mpv-player";
      rev = "70b991749df389bcc0a4e145b5687233a03b4ed7";
      sha256 = "0000000000000000000000000000000000000000000000000000000000000000";
    };
  });
}
