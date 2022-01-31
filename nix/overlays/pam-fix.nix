final: prev:
let
  patchedPkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/ffdadd3ef9167657657d60daf3fe0f1b3176402d.tar.gz";
      sha256 = "1nrz4vzjsf3n8wlnxskgcgcvpwaymrlff690f5njm4nl0rv22hkh";
    })
    {
      inherit (final) system config;
      inherit (prev) overlays;
    };
  patchedPam = patchedPkgs.pam;
in
{
  swaylock = prev.swaylock.override { pam = patchedPam; };
}
