final: prev: {
  mosh = prev.mosh.overrideAttrs (_: {
    src = final.fetchFromGitHub {
      owner = "mobile-shell";
      repo = "mosh";
      rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
      sha256 = "sha256-oQ0r1DezTnYHBQrk6u8jx4UOxQXvuzkzJ25S1n+auyY=";
    };

    patches = [
      (final.fetchpatch {
        url = "https://gist.githubusercontent.com/lovesegfault/dedd37512507cce2d209e924067af860/raw/f479e158d81ebd6807b4fa3783f9a3036503c6b9/gistfile0.txt";
        sha256 = "sha256-wNBNqpTfPVWB4tBeYOXU6D7DsXXkKuQxmfOQ5BbKVcw=";
      })
    ];

    postPatch = ''
      substituteInPlace scripts/mosh.pl \
          --subst-var-by ssh "${final.openssh}/bin/ssh"
      substituteInPlace scripts/mosh.pl \
          --subst-var-by mosh-client "$out/bin/mosh-client"
    '';
  });
}
