final: prev: {
  linux-firmware = prev.linux-firmware.overrideAttrs (_: {
    version = "unstable-2022-01-11";

    src = final.fetchgit {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
      rev = "13dca280f76009ba2c5f25408543a1aaaa062c25";
      sha256 = "sha256-THnf5oWAFh5thCKoKH/kZcO0VU8QDETorG2xR51fmTk=";
    };

    outputHash = "sha256-Xm9QSrDZOli585YvJPEtQThDxUx88Mykyv5tdoXa7Xw=";
  });
}
