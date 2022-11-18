final: prev: {
  lollypop = prev.lollypop.overrideAttrs (_: rec {
    version = "1.4.35";

    src = final.fetchgit {
      url = "https://gitlab.gnome.org/World/lollypop";
      rev = "refs/tags/${version}";
      fetchSubmodules = true;
      sha256 = "sha256-Rdp0gZjdj2tXOWarsTpqgvSZVXAQsCLfk5oUyalE/ZA=";
    };
  });
}
