{ pkgs, ... }: {
  users.users.alessandro = {
    createHome = true;
    description = "Alessandro Re";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCqOZozeMZce1o5fRw2Bk2RazZtG+eTy3AMW7nzyR8rqs2R/zKI8LwVKJ8IMHkGwgNIZci/xjbH36hjbeGq0vEbOKCrZSLijpR2KrInj6XDsbMe1bVohaofCf2qziTNueraIm2xnLG1p0DugdGUj3M9a9ywtMX43OkC4v76O/iGJp+by0auG1jI3en/svFQDvp4jUM6h4CHbzUIevOu9pTty+pWYPw02WUud8IYCyXvWDNxLFqMmscfGjvGfj8pwVKjeMDM9SwVkeE6ka/o1yFQjrSVdVq2kPUFkxNmt5NdNV1CfqC7GXfbE2CrkpSfL2/nfimpyUSNk+yl4BAr50Xj4Tgxz2e6wzVeUlR+nsP+/sSop90PFComlzhUBFOOBppuiBbA59ydcjOeQpWe3xCtXzEm32L08eLj4VwlOyRC9bI9EgKEfziC9TCNbfo6r3+S107Xn5MCOWFOLBLe4TxC1C+vDf6R/9fWrIa+RSBA5rgF8RviWmAiwATIUgTBSc= are@eva01"
    ];
  };
  home-manager.users.alessandro = {
    home.packages = with pkgs; [ ];
  };
}
