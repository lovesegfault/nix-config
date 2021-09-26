self: _: {
  screenshot = self.callPackage
    (
      { writeSaneShellScriptBin
      , libnotify
      , grim
      , slurp
      , swappy
      , wl-clipboard
      }: writeSaneShellScriptBin {
        name = "screenshot";

        buildInputs = [ libnotify grim slurp swappy wl-clipboard ];

        src = ''
          grim -t png -g "$(slurp)" - \
            | swappy -f -
        '';
      }
    )
    { };
}
