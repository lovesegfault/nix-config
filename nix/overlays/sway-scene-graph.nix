final: prev: {
  wlroots-unstable = prev.wlroots.overrideAttrs (_: {
    version = "unstable-2022-09-11";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "Nefsen402";
      repo = "wlroots";
      rev = "63353163271c6e534c293a93699f33a709dbee95";
      hash = "sha256-ROAWTZ2vxT99mbkwOXb3CEXsB/FadLDUvuUt5XVcc1o=";
    };
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    pname = "sway-scene-graph";
    version = "unstable-2022-09-04";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "606cbfc28b6099f8dea036a2a11566111fd9e8d8";
      hash = "sha256-QF6yVpp/GPgYwB28RBIT7Vehi1EJm+OOdeS4MOzl5u8=";
    };

    buildInputs = old.buildInputs ++ (with final; [
      pcre2
      xorg.xcbutilwm
    ]);
  })).override { wlroots = final.wlroots-unstable; };
}
