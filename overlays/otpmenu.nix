self: super: let
  gopassmenu = import ./gopassmenu.nix { inherit super; };
  gopass = "${super.gopass}/bin/gopass";
in {
  otpmenu = super.writeScriptBin "otpmenu" ''
    #!${super.stdenv.shell}

    GOPASS_FILTER="^(otp)/.*$"

    function gopass_get() {
      local name="$1"
      ${gopass} otp $name | cut -f 1 -d ' '
    }

    ${gopassmenu}
  '';
}
