{
  nixpkgs.overlays = [
    (self: super: {
      arcanist = let
        permPatch = super.fetchpatch {
          name = "no-perm-check.patch";
          url =
            "https://gist.githubusercontent.com/lovesegfault/32ddd009f41cbd785d21db1b3d95c810/raw/a5fe1f60f1eee5b5dd35865bce8b8e8cc5a59a2c/no-perm-check.patch";
          sha256 = "151asgn7wnncr2rmaspmhghj0f19qhcwjsfm019jnfn1hl739h9s";
        };
        libphutil = super.fetchFromGitHub {
          owner = "phacility";
          repo = "libphutil";
          rev = "cc2a3dbf590389400da55563cb6993f321ec6d73";
          sha256 = "1k7sr3racwz845i7r5kdwvgqrz8gldz07pxj3yw77s58rqbix3ad";
        };
        arcanist = super.fetchFromGitHub {
          owner = "phacility";
          repo = "arcanist";
          rev = "21a1828ea06cf031e93082db8664d73efc88290a";
          sha256 = "05rq9l9z7446ks270viay57r5ibx702b5bnlf4ck529zc4abympx";
        };
      in (super.arcanist.overrideAttrs (old: {
        src = [ arcanist libphutil ];
        patches = [ permPatch ];
        version = "20200127";
      }));
    })
  ];
}
