{ fzf
, gopass
, libnotify
, ripgrep
, wl-clipboard
, writeSaneShellScriptBin

, name
, filter
, getter
, terminal
}:
writeSaneShellScriptBin {
  inherit name;

  buildInputs = [
    fzf
    gopass
    libnotify
    ripgrep
    wl-clipboard
  ];

  src = ''
    gopassmenu_path="$(readlink -f "$0")"
    gopassmenu_fifo="/tmp/gopassmenu_fifo"
    gopassmenu_lock="/tmp/gopassmenu_lock"

    function gopassmenu_lock() {
        if [[ -f "$gopassmenu_lock" ]]; then
            notify-send "✖️ gopassmenu already running"
            exit 1
        else
            touch "$gopassmenu_lock"
            trap 'rm -f $gopassmenu_lock' EXIT
        fi
    }

    function gopassmenu_frontend() {
        name="$(gopass ls -f | rg "${filter}" | fzf)"
        echo "$name" > "$gopassmenu_fifo"
    }

    function gopassmenu_backend() {
        gopassmenu_lock
        export GOPASSMENU_FRONTEND=1
        ${terminal} -T ${name} "$gopassmenu_path" || true

        name="$(cat "$gopassmenu_fifo")"
        rm -f "$gopassmenu_fifo"
        if [ "$name" == "" ]; then
            exit 1
        fi

        local password
        password="$(gopass ${getter})"

        wl-copy -o "$password"
    }

    if [[ -v GOPASSMENU_FRONTEND ]]; then
        gopassmenu_frontend
    else
        gopassmenu_backend
    fi
  '';
}
