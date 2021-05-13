{ gopass
, libnotify
, ripgrep
, wl-clipboard
, wofi
, writeSaneShellScriptBin
}:
writeSaneShellScriptBin {
  name = "otpmenu";

  buildInputs = [
    gopass
    libnotify
    ripgrep
    wl-clipboard
    wofi
  ];

  src = ''
    otp_list="$(gopass ls -f | rg "^(otp)/.*$")"
    otp_name="$(wofi --show dmenu <<< "$otp_list")"
    otp="$(gopass otp "$otp_name" | cut -f1 -d" ")"
    wl-copy --trim-newline <<< "$otp"
    notify-send "⏲ Copied $otp_name to clipboard."
  '';
}
