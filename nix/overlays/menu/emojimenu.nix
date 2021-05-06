{ fetchurl
, fzf
, jq
, libnotify
, runCommand
, wl-clipboard
, writeSaneShellScriptBin

, terminal
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

  buildInputs = [ fzf libnotify wl-clipboard ];

  src = ''
    emojimenu_path="$(readlink -f "$0")"
    emojimenu_fifo="/tmp/emojimenu_fifo"
    emojimenu_lock="/tmp/emojimenu_lock"

    function emojimenu_lock() {
      if [[ -f "$emojimenu_lock" ]]; then
        notify-send "✖️ emojimenu already running"
        exit 1
      else
        touch "$emojimenu_lock"
        trap 'rm -f $emojimenu_lock' EXIT
      fi
    }

    function emojimenu_frontend() {
      emoji="$(fzf < ${emojis} | cut -f 1 | tr -d '\n')"
      echo "$emoji" > "$emojimenu_fifo"
    }

    function emojimenu_backend() {
      emojimenu_lock
      export EMOJIMENU_FRONTEND=1
      ${terminal} -T emojimenu "$emojimenu_path" || true

      emoji="$(cat "$emojimenu_fifo")"
      rm -f "$emojimenu_fifo"
      if [ "$emoji" == "" ]; then
        exit 1
      fi

      echo "$emoji" | wl-copy -n
    }

    if [[ -v EMOJIMENU_FRONTEND ]]; then
      emojimenu_frontend
    else
      emojimenu_backend
    fi
  '';
}
