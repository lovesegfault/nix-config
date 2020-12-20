{ pkgs, terminal }:
let
  emoji_json = pkgs.fetchurl {
    name = "emojis.json";
    url = "https://raw.githubusercontent.com/github/gemoji/d98617abf23cee2594381045440ad3cce490d12c/db/emoji.json";
    sha256 = "0dd1mlhw2cfpr4l06f12xmapypvmg3299nxkqs0af8l8whq97jnz";
  };
  emojis = pkgs.runCommand "emojis.txt"
    { nativeBuildInputs = [ pkgs.jq ]; } ''
    cat ${emoji_json} | jq -r '.[] | "\(.emoji) \t   \(.description)"' | sed -e 's,\\t,\t,g' > $out
  '';
in
pkgs.writeScriptBin "emojimenu" ''
  #!${pkgs.stdenv.shell}
  emojimenu_path="$(readlink -f "$0")"
  emojimenu_fifo="/tmp/emojimenu_fifo"
  emojimenu_lock="/tmp/emojimenu_lock"

  function emojimenu_lock() {
    if [[ -f "$emojimenu_lock" ]]; then
      ${pkgs.libnotify}/bin/notify-send "✖️ emojimenu already running"
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

  function emojimenu_window() {
    emoji="$(${pkgs.fzf}/bin/fzf < ${emojis} | cut -f 1 | tr -d '\n')"
    echo "$emoji" > "$emojimenu_fifo"
  }

  function emojimenu_backend() {
    emojimenu_lock
    export EMOJIMENU_BEHAVE_AS_WINDOW=1
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

  if [[ -v EMOJIMENU_BEHAVE_AS_WINDOW ]]; then
    emojimenu_window
  else
    emojimenu_backend
  fi
''
