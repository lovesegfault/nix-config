final: prev: {
  klipper = prev.klipper.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "klipper3d";
      repo = "klipper";
      rev = "d32a83345518f4bb632bef9ca2de669b35f0e555";
      hash = "sha256-XpAUv4NVERVGxV4lk6u15lIIce8ZrYf9uN3fdL5xolI=";
    };

    buildInputs = [ (final.python3.withPackages (p: with p; [ can cffi pyserial greenlet jinja2 markupsafe numpy ])) ];
  });
}
