{ pkgs, ... }: {
  users.users.cloud = {
    createHome = true;
    description = "Phillip Cloud";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfPRiesz2VviTkRJAd3mzGRm2P+K67SutblfJ9I1+rU cloud@standard.ai"
    ];
  };
  home-manager.users.cloud = {
    home.packages = with pkgs; [ hello ];
  };
}
