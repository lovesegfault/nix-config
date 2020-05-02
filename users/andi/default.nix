{ pkgs, ... }: {
  users.users.andi = {
    createHome = true;
    description = "Andreas Rammhold";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzEgSlI+BBAFbQdQ3Q7iGrMedBRGFpJZkOYG7CDjrsA andi@wrt"
    ];
  };
  home-manager.users.andi = {
    home.packages = with pkgs; [ hello ];
  };
}
