{ fetchurl
, jq
, runCommand
, wl-clipboard
, wofi
, writeSaneShellScriptBin
}:
let
  emoji_json = fetchurl {
    name = "emojis.json";
    url = "https://raw.githubusercontent.com/github/gemoji/b1c7878afeb260d2ff6dc6655bf3aa7dee498e9c/db/emoji.json";
    sha256 = "sha256-bL+4ft3yzVUnVxDg7cwoS2hvbeqEKvhx77QjEgR+Yhk=";
  };
  emojis = runCommand "emojis.txt"
    { nativeBuildInputs = [ jq ]; } ''
    cat ${emoji_json} | jq -r '.[] | "\(.emoji) \t   \(.description)"' | sed -e 's,\\t,\t,g' > $out
  '';
in
writeSaneShellScriptBin {
  name = "emojimenu";

  buildInputs = [ wl-clipboard wofi ];

  src = ''
    emoji="$(wofi --show dmenu -D "allow_markup=false" < ${emojis} | cut -f 1)"
    wl-copy -n <<< "$emoji"
  '';
}
