final: prev: {
  hwdata_364 = final.hwdata.overrideAttrs (_: rec {
    version = "0.364";

    src = final.fetchFromGitHub {
      owner = "vcrhonek";
      repo = "hwdata";
      rev = "v${version}";
      hash = "sha256-9fGYoyj7vN3j72H+6jv/R0MaWPZ+4UNQhCSWnZRZZS4=";
    };

    outputHash = null;
  });

  wlroots_0_17 = final.wlroots_0_15.overrideAttrs (old: {
    version = "unstable-2022-11-11";

    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "2b22a1047840912c8c86781282faa5aa08684f64";
      sha256 = "sha256-xkaD5pUG6hcnSnssLXb2CLGtQ+nJxYlG0QVnYgrzwco=";
    };

    buildInputs = old.buildInputs ++ [ final.hwdata_364 ];
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    version = "scene-graph-2022-11-11";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "fc97730895c10016f8e97bf44d872b46c325090a";
      hash = "sha256-p5c3NDumHnJcBzPYTJJMj9VjYE8nQWywf2TkBccv834=";
    };

    buildInputs = old.buildInputs ++ (with final; [ pcre2 xorg.xcbutilwm ]);
  })).override { wlroots = final.wlroots_0_17; };
}
