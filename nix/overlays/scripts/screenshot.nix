final: _: {
  screenshot = final.callPackage
    (
      { writeShellApplication
      , libnotify
      , grim
      , slurp
      , swappy
      , wl-clipboard
      }: writeShellApplication {
        name = "screenshot";

        runtimeInputs = [ libnotify grim slurp swappy wl-clipboard ];

        text = ''
          grim -t png -g "$(slurp)" - \
            | swappy -f -
        '';
      }
    )
    { };
}
