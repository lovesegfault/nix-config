{ stdenv
, fetchurl
, fzf
, jq
, lib
, libnotify
, runCommand
, wl-clipboard
, writeScriptBin

, terminal
}:
let
  emoji_json = fetchurl {
    name = "emojis.json";
    url = "https://raw.githubusercontent.com/github/gemoji/d98617abf23cee2594381045440ad3cce490d12c/db/emoji.json";
    sha256 = "0dd1mlhw2cfpr4l06f12xmapypvmg3299nxkqs0af8l8whq97jnz";
  };
  emojis = runCommand "emojis.txt"
    { nativeBuildInputs = [ jq ]; } ''
    cat ${emoji_json} | jq -r '.[] | "\(.emoji) \t   \(.description)"' | sed -e 's,\\t,\t,g' > $out
  '';
in
writeScriptBin "emojimenu" ''
  #!${stdenv.shell}
  export PATH="${lib.makeBinPath [ fzf libnotify wl-clipboard ]}:$PATH"

  emojimenu_path="$(readlink -f "$0")"
  emojimenu_fifo="/tmp/emojimenu_fifo"
  emojimenu_lock="/tmp/emojimenu_lock"

  function emojimenu_lock() {
    if [[ -f "$emojimenu_lock" ]]; then
      notify-send "✖️ emojimenu already running"
      exit 1
    else
      touch "$emojimenu_lock"
    fi
  }

  function emojimenu_unlock() {
    if [[ -f "$emojimenu_lock" ]]; then
      rm -f "$emojimenu_lock"
    fi
  }

  function emojimenu_frontend() {
    emoji="$(fzf < ${emojis} | cut -f 1 | tr -d '\n')"
    echo "$emoji" > "$emojimenu_fifo"
  }

  function emojimenu_backend() {
    emojimenu_lock
    export EMOJIMENU_FRONTEND=1
    ${terminal} -t emojimenu -e "$emojimenu_path"

    emoji="$(cat "$emojimenu_fifo")"
    rm -f "$emojimenu_fifo"
    if [ "$emoji" == "" ]; then
      emojimenu_unlock
      exit 1
    fi

    echo "$emoji" | wl-copy -n
    emojimenu_unlock
  }

  if [[ -v EMOJIMENU_FRONTEND ]]; then
    emojimenu_frontend
  else
    emojimenu_backend
  fi
''
