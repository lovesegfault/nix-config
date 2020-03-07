self: super: let
    menu = import ./execmenu.nix { inherit super; };
in {
  i3menu = super.writeScriptBin "i3menu" ''
    #!${super.stdenv.shell}
    ${menu}
    (exec i3-msg -t command "exec $COMMAND")
  '';
}
