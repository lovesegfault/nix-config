final: prev: {
  klipper = prev.klipper.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "klipper3d";
      repo = "klipper";
      rev = "0245073c550bba95f071893c68120dbe2a5d8219";
      hash = "sha256-nkof4GQ/5D1NS0+w4H/iZdgQnF8PbwjQdIYedymu9I4=";
    };

    buildInputs = [ (final.python3.withPackages (p: with p; [ can cffi pyserial greenlet jinja2 markupsafe numpy ])) ];
  });
}
