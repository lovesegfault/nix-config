{ pkgs, ... }: {
  users.users.naser = {
    createHome = true;
    description = "Naser Derakhshan";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    # FIXME
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 00000000000000000000000000000000000000000000000000000000000000000000 yo soy un template"
    # ];
  };
  home-manager.users.naser = {
    home.packages = with pkgs; [ hello ];
  };
}
