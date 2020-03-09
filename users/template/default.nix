{ pkgs, ... }: {
  users.users.template = {
    createHome = true;
    description = "I am a template";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 00000000000000000000000000000000000000000000000000000000000000000000 yo soy un template"
    ];
  };
  home-manager.users.template = {
    home.packages = with pkgs; [ hello ];
  };
}
