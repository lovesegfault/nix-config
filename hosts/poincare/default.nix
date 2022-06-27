{ config, pkgs, ... }: {
  imports = [
    ../../users/bemeurer/core
    ../../users/bemeurer/dev
    ../../users/bemeurer/modules
  ];

  home = {
    uid = 504;
    sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
      "/opt/homebrew/bin"
    ];
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      btop
      nix
      openssh
    ];
    shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
