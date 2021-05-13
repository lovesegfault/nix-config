self: super: {
  beets = super.beets.overridePythonAttrs (_: {
    version = "unstable-2021-05-13";

    src = self.fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "1faa41f8c558d3f4415e5e48cf4513d50b466d34";
      sha256 = "sha256-P0bV7WNqCYe9+3lqnFmAoRlb2asdsBUjzRMc24RngpU=";
    };
    FIXME = "REMOVE";
  });
}
