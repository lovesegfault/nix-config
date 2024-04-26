final: prev: {
  nix-eval-jobs = (prev.nix-eval-jobs.overrideAttrs (old: rec {
    version = "2.21.0";
    src = final.fetchFromGitHub {
      owner = "nix-community";
      repo = old.pname;
      rev = "v${version}";
      hash = "sha256-StJq7Zy+/iVBUAKFzhHWlsirFucZ3gNtzXhAYXAsNnw=";
    };
  })).override { nix = final.nixVersions.nix_2_21; };
}
