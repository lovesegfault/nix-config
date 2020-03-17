{ pkgs, ... }:
{
  boot = {
    kernelPatches = [
      {
        name = "nouveau-gr-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/b681472f15f5e5c61653edd00ee4c297620a026b.patch";
            sha256 = "0cqg6yc22aqflzjf5xijy4rc78hxi9bhdnbhm671xm4bksp4ad34";
          }
        );
      }
      {
        name = "nouveau-runpm-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://github.com/karolherbst/linux/commit/a2bc9baeba679da6a3fa284b97ce99e672f354bc.patch";
            sha256 = "0gnrk1hksxjz8a59z94vj6bhcd4f0mv3jzyvyv9p3j0jk521klm7";
          }
        );
      }
    ];
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ libva-full libvdpau-va-gl vaapiVdpau ];
    };
  };
}
