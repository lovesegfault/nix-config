{ config, lib, pkgs, ... }:
{
  boot = {
    kernelPatches = [
      {
        name = "nouveau-gr-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/0a4d0a9f2ab29b4765ee819753fbbcbc2aa7da97.patch";
            sha256 = "1k4lf1cnydckjn2fqdqiizba3rzjg27xa97xjaif4ss5m7mh4ckn";
          }
        );
      }
      {
        name = "nouveau-runpm-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/1e6cef9e6c4d17f6d893dae3cd7d442d8574b4b5.patch";
            sha256 = "103myhwmi55f7vaxk9yqrl4diql6z32am5mzd6kvk89j9m02h528";
          }
        );
      }
    ];
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = [ libva-full libvdpau-va-gl vaapiVdpau ];
    };
  };
}
