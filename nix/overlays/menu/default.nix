self:
let
  terminal = "${self.foot}/bin/foot";
in
_:
{
  sway-launcher-desktop = self.callPackage ./sway-launcher-desktop.nix { inherit terminal; };

  emojimenu = self.callPackage ./emojimenu.nix { };

  otpmenu = self.callPackage ./otpmenu.nix { };

  passmenu = self.callPackage ./passmenu.nix { };
}
