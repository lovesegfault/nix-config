{ pkgs, name, filter, terminal, getter }:
pkgs.writeScriptBin name ''
  #!${pkgs.stdenv.shell}
  gopassmenu_path="$(readlink -f "$0")"
  gopassmenu_fifo="/tmp/gopassmenu_fifo"
  gopassmenu_lock="/tmp/gopassmenu_lock"

  function gopassmenu_lock() {
      if [[ -f "$gopassmenu_lock" ]]; then
          ${pkgs.libnotify}/bin/notify-send "✖️ gopassmenu already running"
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

  function gopassmenu_window() {
      name="$(${pkgs.gopass}/bin/gopass ls -f | ${pkgs.ripgrep}/bin/rg "${filter}" | ${pkgs.fzf}/bin/fzf)"
      echo "$name" > "$gopassmenu_fifo"
  }

  function gopassmenu_backend() {
      gopassmenu_lock
      export GOPASSMENU_BEHAVE_AS_WINDOW=1
      ${terminal} -t ${name} -e "$gopassmenu_path"

      name="$(cat "$gopassmenu_fifo")"
      rm -f "$gopassmenu_fifo"
      if [ "$name" == "" ]; then
          gopassmenu_unlock
          exit 1
      fi

      local password="$(${getter})"
      ${pkgs.wl-clipboard}/bin/wl-copy -o "$password"
      gopassmenu_unlock
  }

  if [[ -v GOPASSMENU_BEHAVE_AS_WINDOW ]]; then
      gopassmenu_window
  else
      gopassmenu_backend
  fi
''
