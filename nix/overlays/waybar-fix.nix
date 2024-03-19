final: prev: {
  wireplumber-0_4 = final.wireplumber.overrideAttrs (_: rec {
    version = "0.4.17";
    src = final.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
  waybar = prev.waybar.override { wireplumber = final.wireplumber-0_4; };
}
