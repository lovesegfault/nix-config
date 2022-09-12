final: prev: {
  wlroots-unstable = prev.wlroots.overrideAttrs (_: {
    version = "unstable-2022-09-11";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "4cc3abb96676afaffda064ededb9c5ebe92a821f";
      hash = "sha256-wQGEZOj/j1tUeJg5l0hLPR9poTUiI4uciA40HAjGJws=";
    };
  });

  sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
    pname = "sway-scene-graph";
    version = "unstable-2022-09-04";
    src = final.fetchFromGitHub {
      owner = "Nefsen402";
      repo = "sway";
      rev = "4be5102e6504d70d2b73421e386a63fdf3039f9a";
      hash = "sha256-doOqK6owQA7nZNDGQ9f/r4nzy+z7F0yNXhtlwlRbDLg=";
    };

    buildInputs = old.buildInputs ++ (with final; [
      pcre2
      xorg.xcbutilwm
    ]);
  })).override { wlroots = final.wlroots-unstable; };
}
