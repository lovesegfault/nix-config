self:
let
  terminal = "${self.foot}/bin/foot";
in
_:
{
  sway-launcher-desktop = self.callPackage ./sway-launcher-desktop.nix { inherit terminal; };

  emojimenu = self.callPackage ./emojimenu.nix { inherit terminal; };

  otpmenu = self.callPackage ./gopassmenu.nix {
    inherit terminal;
    name = "otpmenu";
    filter = "^(otp)/.*$";
    getter = "otp \"$name\" | cut -f 1 -d ' '";
  };

  passmenu = self.callPackage ./gopassmenu.nix {
    inherit terminal;
    name = "passmenu";
    filter = "^(misc|hosts|websites)/.*$";
    getter = "show --password \"$name\"";
  };
}
