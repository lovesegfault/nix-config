self: super: {
  pipewire = super.pipewire.overrideAttrs (oldAttrs: rec {
    version = "0.3.21";
    src = self.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "pipewire";
      rev = version;
      hash = "sha256:2YJzPTMPIoQQeNja3F53SD4gtpdSlbD/i77hBWiQfuQ=";
    };
  });
}
