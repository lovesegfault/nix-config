self: super: {
  mosh = super.mosh.overrideAttrs (
    _: {
      src = self.fetchFromGitHub {
        owner = "mobile-shell";
        repo = "mosh";
        rev = "0cc492dbae2f6aaef9a54dc2a8ba3222868b150f";
        sha256 = "0w7jxdsyxgnf5h09rm8mfgm5z1qc1sqwvgzvrwzb04yshxpsg0zd";
      };
      patches = [
        (self.fetchpatch {
          url = "https://raw.githubusercontent.com/xfix/nixpkgs/d655b917c1f594be01258c346b779414b93cca41/pkgs/tools/networking/mosh/bash_completion_datadir.patch";
          sha256 = "04k1k33zh66k0mzdblj8zdci1jki93vnir876mkr1572kjaycwkw";
        })
      ];
    }
  );
}
