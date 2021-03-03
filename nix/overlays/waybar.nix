self: super: {
  waybar = super.waybar.overrideAttrs (oldAttrs: rec {
    version = "unstable-2021-02-23";
    src = self.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "cb1c7ea12cdda26983463e7e3ab0cc0d08f674ff";
      sha256 = "sha256-gtbfCLzgNq2FRB2bJXovSFMSRrHT3/uOrv7HGUc13dI=";
    };
  });
}
