{ pkgs, ... }: {
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };
}
