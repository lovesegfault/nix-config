self: super: {
  mosh = super.mosh.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "mobile-shell";
      repo = "mosh";
      rev = "0cc492dbae2f6aaef9a54dc2a8ba3222868b150f";
      sha256 = "0w7jxdsyxgnf5h09rm8mfgm5z1qc1sqwvgzvrwzb04yshxpsg0zd";
    };
    patches = [];
  });
}
