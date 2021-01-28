{ stdenv
, fzf
, gopass
, lib
, libnotify
, ripgrep
, wl-clipboard
, writeScriptBin

, name
, filter
, getter
, terminal
}:
writeScriptBin name ''
  #!${stdenv.shell}
  export PATH="${lib.makeBinPath [ fzf gopass libnotify ripgrep wl-clipboard ]}:$PATH"

  gopassmenu_path="$(readlink -f "$0")"
  gopassmenu_fifo="/tmp/gopassmenu_fifo"
  gopassmenu_lock="/tmp/gopassmenu_lock"

  function gopassmenu_lock() {
      if [[ -f "$gopassmenu_lock" ]]; then
          notify-send "✖️ gopassmenu already running"
          exit 1
      else
          touch "$gopassmenu_lock"
      fi
  }

  function gopassmenu_unlock() {
      if [[ -f "$gopassmenu_lock" ]]; then
          rm -f "$gopassmenu_lock"
      fi
  }

  function gopassmenu_frontend() {
      name="$(gopass ls -f | rg "${filter}" | fzf)"
      echo "$name" > "$gopassmenu_fifo"
  }

  function gopassmenu_backend() {
      gopassmenu_lock
      export GOPASSMENU_FRONTEND=1
      ${terminal} -t ${name} -e "$gopassmenu_path"

      name="$(cat "$gopassmenu_fifo")"
      rm -f "$gopassmenu_fifo"
      if [ "$name" == "" ]; then
          gopassmenu_unlock
          exit 1
      fi

      local password="$(gopass ${getter})"
      wl-copy -o "$password"
      gopassmenu_unlock
  }

  if [[ -v GOPASSMENU_FRONTEND ]]; then
      gopassmenu_frontend
  else
      gopassmenu_backend
  fi
''
