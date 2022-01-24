final: prev: {
  linux-firmware = prev.linux-firmware.overrideAttrs (_: {
    version = "unstable-2022-01-11";

    src = final.fetchgit {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
      rev = "0c6a7b3bf728b95c8b7b95328f94335e2bb2c967";
      sha256 = "sha256-r3n0beZ/QqnFmrm48kpsfSbnXWWxVDggsBsbXCrueQE=";
    };

    outputHash = "sha256-npcSuoAVanRja/8jagsveVjLjjM9p2xKRj5kdWmxEUs=";
  });
}
