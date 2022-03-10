# This is used in CI to mask the building of packages with very large closures,
# hopefully allowing GitHub to build a subset of the system drv

final: prev:
let
  maskedPkgs = [
    "darktable"
    "discord"
    "element-desktop"
    "firefox-bin"
    "firefox-unwrapped"
    "signal-desktop"
    "spotify"
    "thunderbird"
    "zoom-us"
  ];
  inherit (prev.lib) listToAttrs makeOverridable nameValuePair;
  nullDrv = final.callPackage
    ({ runCommand, ... }:
      runCommand "dummy" { } ''
        mkdir -p $out/{bin,lib}
        echo "dummy" > $out/bin/dummy
        echo "dummy" > $out/lib/dummy
        runHook postInstall
      '')
    { };

  dummyOverrides = listToAttrs (map (p: nameValuePair p nullDrv) maskedPkgs);
in
dummyOverrides // {
  linuxPackages_latest_lto_skylake = prev.linuxPackages_latest_lto_skylake.extend (_: prev: {
    nvidiaPackages = prev.nvidiaPackages // {
      stable = nullDrv.overrideAttrs (_: {
        inherit (prev.nvidiaPackages.stable) useProfiles version;
        bin = nullDrv;
        persistenced = nullDrv;
        lib32 = nullDrv;
        postInstall = ''
          touch $out/bin/nvidia-sleep.sh
          mkdir -p $out/lib/systemd/system-sleep
          touch $out/lib/systemd/system-sleep/nvidia
        '';
      });
    };
  });
}
