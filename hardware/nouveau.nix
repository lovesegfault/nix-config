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
      {
        name = "nouveau-hdmi2-fix";
        patch = (
          pkgs.fetchpatch {
            url = "https://gist.githubusercontent.com/lovesegfault/52b60b9a1be8bcca3a70651da24b61e7/raw/72d884457c91718475876dc57e3821bb93d11a26/gistfile1.txt";
            sha256 = "0mvawd4m7w1jqh13aidb3xqfgrbgd1z2cybhgdggkn7dg2m9g7bi";
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
