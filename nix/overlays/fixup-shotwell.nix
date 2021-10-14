self: super: {
  shotwell = super.shotwell.overrideAttrs (old: rec {
    version = "0.30.14";
    name = "${old.pname}-${version}";

    src = self.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "shotwell";
      rev = "shotwell-${version}";
      sha256 = "sha256-uDTMS1jOnH3zbiaaPRudoQtKEprNtc4tXomKn6wdkOw=";
    };
  });
}
