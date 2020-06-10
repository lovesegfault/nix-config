{ pkgs, ... }: {
  users.users.ekleog = {
    createHome = true;
    description = "Leo Gaspard";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpQUN+FGyX80jjYX8HZv600c8jCSmhwnC/2mCsn+j/vnm5a3Tw8La7A2LocfKpocVU7cUkZNrPsXrLFOBu3jqM3VYqRlQw6ixgwonb3klpfeUu0kPg72Q6FQHMZO+yLIKwGWYDADFwxXk/KeuZK1VgAq1GGY4AdIB+PgtJ9/63rqtd0ooBX7rfKj+mMVuahS0/wxUhDufHBjv54Kk66JsUHd3gbW6EKa6bLfUQxRbJkxDycs7OvjUmUO0ndxdnqEYMaExbM+j0AFPVEc/7TW8SDL3dXtOEmIttB8nVcja5lpGyxpRJWiAxOBaosY76P5AEvfdt/JgRFdEhcr2F7YyR ekleog@llwynog"
    ];
  };
  home-manager.users.ekleog = {
    home.packages = with pkgs; [ hello ];
  };
}
