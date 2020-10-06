pkgs: _:
let
  terminal =
    if pkgs.hostPlatform.system == "x86_64-linux" then
      "${pkgs.alacritty}/bin/alacritty"
    else
      "${pkgs.termite}/bin/termite";
in
{
  swaymenu = import ./swaymenu.nix { inherit pkgs terminal; };

  emojimenu = import ./emojimenu.nix { inherit pkgs terminal; };

  otpmenu = import ./gopassmenu.nix {
    inherit pkgs terminal;
    name = "otpmenu";
    filter = "^(otp)/.*$";
    getter = "${pkgs.gopass}/bin/gopass otp $name | cut -f 1 -d ' '";
  };

  passmenu = import ./gopassmenu.nix {
    inherit pkgs terminal;
    name = "passmenu";
    filter = "^(misc|ssh|websites)/.*$";
    getter = "${pkgs.gopass}/bin/gopass show --password \"$name\"";
  };
}
