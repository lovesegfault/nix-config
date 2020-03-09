{ pkgs, ... }: {
  users.users.ogle = {
    createHome = true;
    description = "Brandon Ogle";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMbxQQ6asa917aD8HTavEinmIEsm6G3pZEOv7Rf33JCvvrdCW5ktOsjBm0oeRLt3aeC0QZa3nrMXixP7GCmJQWFPnAsQLlrpZnNRte5GB9X0wcUTUcvLo1kXzTBB5CRhSwdVQ9+/Ztc+LSiObPqFfsYY2pa85wYU6Q+Hu+aYSDrTvCzcL1ojEvUKnOmSWFYQ+fmYV7skKJL3Xr66zpWeCKyVtY8h7Ju3H3IWZTTl8Fyqtej63uHxqjQlMNzEjUL9Nzmev+O8+lCKvHXG+8dQBAYe3+tsIi1NKLSODSKxLpka52XIiNrgGnnr74YTZ8sp8Sd9STr3HUPr7uNK5I8DSL brandon@standard.ai"
    ];
  };
  home-manager.users.ogle = {
    home.packages = with pkgs; [ hello ];
  };
}
