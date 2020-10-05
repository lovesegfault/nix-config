self: super:
let
  terminal =
    if self.hostPlatform.system == "x86_64-linux" then
      "${self.alacritty}/bin/alacritty"
    else
      "${self.termite}/bin/termite";
in
{
  swaymenu = import ./swaymenu.nix { inherit terminal; pkgs = self; };

  emojimenu = import ./emojimenu.nix { inherit terminal; pkgs = self; };

  otpmenu = import ./gopassmenu.nix {
    inherit terminal;
    pkgs = self;
    name = "otpmenu";
    filter = "^(otp)/.*$";
    getter = "${self.gopass}/bin/gopass otp $name | cut -f 1 -d ' '";
  };

  passmenu = import ./gopassmenu.nix {
    inherit terminal;
    pkgs = self;
    name = "passmenu";
    filter = "^(misc|ssh|websites)/.*$";
    getter = "${self.gopass}/bin/gopass show --password \"$name\"";
  };
}
