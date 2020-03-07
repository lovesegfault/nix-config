self: super: let
  menu = import ./execmenu.nix { inherit super; };
in {
  swaymenu = super.writeScriptBin "swaymenu" ''
    #!${super.stdenv.shell}
    ${menu}
    (exec swaymsg -t command "exec $COMMAND")
  '';
}
