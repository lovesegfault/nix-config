{ pkgs, ... }:
let
  emoji_json = pkgs.fetchurl {
    name = "emojis.json";
    url =
      "https://raw.githubusercontent.com/github/gemoji/fd84af55cff8cfdf56ef9635bbd5fef5c8179672/db/emoji.json";
    sha256 = "1ccaz1pxfraf8f7zb4z4p3siknvlkhpr13xp50rs3spbn8shm0sa";
  };
  emojis = pkgs.runCommand "emojis.txt" { nativeBuildInputs = [ pkgs.jq ]; } ''
    cat ${emoji_json} | jq -r '.[] | "\(.emoji) \t   \(.description)"' | sed -e 's,\\t,\t,g' > $out
  '';

in {
  nixpkgs.overlays = [
    (self: super: {
      emojimenu = super.writeScriptBin "emojimenu" ''
        #!${super.stdenv.shell}
        exec fzf < ${emojis} | cut -f1 | tr -d '\n'
      '';
      emojicopy = super.writeScriptBin "emojicopy" ''
        #!${super.stdenv.shell}
        set +x
        ${self.emojimenu}/bin/emojimenu | ${super.wl-clipboard}/bin/wl-copy -p -n
        sleep 0.1
      '';
    })
  ];
}
