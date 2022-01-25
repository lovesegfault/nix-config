final: prev:
let
  inherit (prev.lib) hiPrio mapAttrsToList;

  glinuxCommands = {
    ssh-agent = "/usr/bin/ssh-agent";
    swaylock = "/usr/bin/swaylock";
  };

  mkImpureDrv = name: _path:
    final.runCommandLocal (name + "-glinux") { } ''
      mkdir -p $out/bin
      ln -s /dangling "$out/bin/${name}"
    '';
  glinuxPkgs = final.symlinkJoin {
    name = "glinux-pkgs";
    paths = mapAttrsToList mkImpureDrv glinuxCommands;
  };
in
{
  glinuxPkgs = hiPrio glinuxPkgs;
}
