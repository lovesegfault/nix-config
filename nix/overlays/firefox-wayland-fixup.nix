self: super: {
  firefox-unwrapped = super.firefox-unwrapped.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (self.fetchpatch {
        url = "https://hg.mozilla.org/integration/autoland/raw-rev/3b856ecc00e4";
        sha256 = "sha256-d8IRJD6ELC3ZgEs1ES/gy2kTNu/ivoUkUNGMEUoq8r8=";
      })
      (self.fetchpatch {
        url = "https://hg.mozilla.org/mozilla-central/raw-rev/51c13987d1b8";
        sha256 = "sha256-C2jcoWLuxW0Ic+Mbh3UpEzxTKZInljqVdcuA9WjspoA=";
      })
    ];
  });
}
