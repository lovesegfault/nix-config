pkgs: _:
let
  terminal =
    if pkgs.hostPlatform.system == "x86_64-linux" then
      "${pkgs.alacritty}/bin/alacritty"
    else
      "${pkgs.termite}/bin/termite";
in
{
  sway-launcher-desktop = pkgs.callPackage ./sway-launcher-desktop.nix { inherit terminal; };

  emojimenu = pkgs.callPackage ./emojimenu.nix { inherit terminal; };

  otpmenu = pkgs.callPackage ./gopassmenu.nix {
    inherit terminal;
    name = "otpmenu";
    filter = "^(otp)/.*$";
    getter = "otp $name | cut -f 1 -d ' '";
  };

  passmenu = pkgs.callPackage ./gopassmenu.nix {
    inherit terminal;
    name = "passmenu";
    filter = "^(misc|ssh|websites)/.*$";
    getter = "show --password \"$name\"";
  };
}
