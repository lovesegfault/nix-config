self: _:
{
  emojimenu = self.callPackage ./emojimenu.nix { };

  otpmenu = self.callPackage ./otpmenu.nix { };

  passmenu = self.callPackage ./passmenu.nix { };
}
