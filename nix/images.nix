{ nixpkgs, ... }@inputs:
let
  inherit (nixpkgs.lib) filterAttrs mapAttrs;

  hosts = import ./hosts.nix;

  aarch64Hosts = filterAttrs
    (_: h: h.system == "aarch64-linux")
    hosts;

  # x86_64Hosts = filterAttrs
  #   (_: h: h.system == "x86_64-linux")
  #   hosts;

  mkAarch64SdImage = name: system:
    let
      host = import ./mk-host.nix {
        inherit inputs name system;
        extraModules = [
          ({ modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];
          })
        ];
      };
    in
    host.config.system.build.sdImage;

  # mkX86_64IsoImage = name: system:
  #   let
  #     host = import ./mk-host.nix {
  #       inherit inputs name system;
  #       extraModules = [
  #         ({ modulesPath, ... }: {
  #           imports = [ (modulesPath + "/installer/cd-dvd/iso-image.nix") ];
  #         })
  #       ];
  #     };
  #   in
  #   host.config.system.build.isoImage;

  aarch64Images = mapAttrs
    (n: v: mkAarch64SdImage n v.system)
    aarch64Hosts;

  # NB: These don't work very well b/c the filesystem definitions clash
  # x86_64Images = mapAttrs
  #   (n: v: mkX86_64IsoImage n v.system)
  #   x86_64Hosts;
in
{
  images = aarch64Images;
}
