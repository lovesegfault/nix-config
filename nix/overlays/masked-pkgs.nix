final: prev:
let
  inherit (prev.lib) hiPrio concatMapStrings;

  maskFromPaths = name: paths:
    hiPrio (
      final.runCommandLocal (name + "-mask") { }
        (concatMapStrings
          (p: ''
            (
              dir="$(dirname ${p})"
              base="$(basename ${p})"

              mkdir -p "$out/$dir"
              ln -s /dangling "$out/$dir/$base"
            )
          '')
          paths)
    );

  # maskFromDrv = drv:
  #   hiPrio (
  #     final.runCommandLocal (drv.pname + "-mask") { } ''
  #       mkdir $out
  #       touch $out/.dummy
  #     ''
  #   );

in
{
  glinux-mask = maskFromPaths "glinux" [
    "/bin/ssh-agent"
    "/bin/swaylock"
  ];

  gixy = final.writeShellScriptBin "gixy" ''
    echo "Ignoring gixy"
  '';
}
