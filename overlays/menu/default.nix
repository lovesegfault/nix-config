self: super:
let
  menu = import ./execmenu.nix { inherit super; };
  gopassmenu = import ./gopassmenu.nix { inherit super; };
  gopass = "${super.gopass}/bin/gopass";
in
{

  i3menu = super.writeScriptBin "i3menu" ''
    #!${super.stdenv.shell}
    ${menu}
    (exec i3-msg -t command "exec $COMMAND")
  '';

  swaymenu = super.writeScriptBin "swaymenu" ''
    #!${super.stdenv.shell}
    ${menu}
    (exec swaymsg -t command "exec $COMMAND")
  '';

  emojimenu = ((import ./emojimenu.nix) self super);

  otpmenu = super.writeScriptBin "otpmenu" ''
    #!${super.stdenv.shell}

    GOPASS_FILTER="^(otp)/.*$"

    function gopass_get() {
      local name="$1"
      ${gopass} otp $name | cut -f 1 -d ' '
    }

    ${gopassmenu}
  '';

  passmenu = super.writeScriptBin "passmenu" ''
    #!${super.stdenv.shell}

    GOPASS_FILTER="^(misc|ssh|websites)/.*$"

    function gopass_get() {
      local name="$1"
      ${gopass} show --password "$name"
    }

    ${gopassmenu}
  '';
}
