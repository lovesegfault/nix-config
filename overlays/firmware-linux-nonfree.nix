self: super: {
  firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (oldAttrs: {
    version = "2020-07-16";
    src = super.fetchgit {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
      rev = "1d1c80b696539caa1d8a51d5f573012fbfa7eb5d";
      sha256 = "1faqvzbd3k5hbxdngyf625qjyp9siqkmi97qh30i4qmdchgzdk4l";
    };
    outputHash = "0b11p2srb8yrbnhcaw061gny1qjxfg7gfhvjybsf51lhikyr20li";
  });
}
