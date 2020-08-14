{ pkgs, ... }: {
  users.users.nagisa = {
    createHome = true;
    description = "Simonas Kazlauskas";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9SSZujXXfr200aG786eyHPGZDEHTRWAZHBlXUHuCbp simonas+shirobox@standard.ai"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4h2+cyU5hfLSkGMEAhoWz6FbX2/s+YE//z/TIBsJJ6 simonas+kumabox@standard.ai"
    ];
  };
  home-manager.users.nagisa = {
    home.packages = with pkgs; [ ];
  };
}
