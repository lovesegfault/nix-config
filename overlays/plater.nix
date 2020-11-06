self: _: {
  plater = self.callPackage
    (self.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/69f25333697aa0bca0a2b60e608b63e9de29a1d7/pkgs/applications/misc/plater/default.nix";
      sha256 = "1nb8hcsvdi16y2zw35x4vn34biihj3mgfi1aa2kn9v4m1c53m4as";
    })
    { };
}
