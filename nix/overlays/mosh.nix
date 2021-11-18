final: prev: {
  mosh = prev.mosh.overrideAttrs (_: {
    src = final.fetchFromGitHub {
      owner = "mobile-shell";
      repo = "mosh";
      rev = "e023e81c08897c95271b4f4f0726ec165bb6e1bd";
      sha256 = "sha256-X2xJCiC5/vSijzZgQsWDzD+R8D8ppdZD6WeG4uoxyYw=";
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
