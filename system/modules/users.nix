{ pkgs, ... }: {
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "camera" "input" "lxd" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
