{
  nixpkgs.overlays = [
    (self: super: {
      xfs-2038-fix = {
        name = "xfs-2038-fix";
        patch = (builtins.fetchurl {
          url = "https://lkml.org/lkml/diff/2019/12/26/349/1";
          sha256 = "1jzxncv97w3ns60nk91b9b0a11bp1axng370qhv4fs7ik01yfsa4";
        });
      };
    })
  ];
}
