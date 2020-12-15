{ pkgs, ... }: {
  imports = [
    ./ssh.nix
    ./gpg.nix
  ];

  home.packages = with pkgs; [ gopass ];

  programs.git.signing = {
    key = "6976C95303C20664";
    signByDefault = true;
  };

  programs.gpg.settings = {
    # Default/trusted key ID to use (helpful with throw-keyids)
    default-key = "0x6976C95303C20664";
    trusted-key = "0x6976C95303C20664";
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };
}
