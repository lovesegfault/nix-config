{ config, pkgs, ... }: {
  imports = [
    ../combo/core.nix
    ../combo/dev.nix
    ../combo/stcg-dc.nix

    ../modules/stcg-cachix.nix
  ];

  networking = {
    hostName = "cantor";
    hostId = "e387c8da";
  };

  time.timeZone = "America/Los_Angeles";

  users.users = {
    aaron = {
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDyK+j2Viz6kb6tSQwUU4tjbJFABIeeLSu4Cn3rnne1svZ7OIpenD2UX6BG/9uFQliiS+S/DaUd3wc+OW7E5U65jo7ujAROPblMNUn7D9/dtiLcRBQ2x8eVwue8ZXOHaqxl/Ez2Xr29E2UUkA8tTKh1zpIWG3Rt/HeOB+nRIzpm/NRD/mA6N1M7YAMEd1KVpNP0zdmRIrWNDGnSCsxM/PlcPhyAmZ2Qg5fJVEUubogHhas42vPxXXEtkJNcboYtbid9GXi7JQmtJGl0diw9kN7Wd/MoqOWjOUHHbDavjguvD5gbbW0Jzdffn9cqe2Ae2KpTG+1FBUS6k/3GqhFOHTXb aaron@Aarons-MacBook-Pro.local"
      ];
    };

    ogle = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMbxQQ6asa917aD8HTavEinmIEsm6G3pZEOv7Rf33JCvvrdCW5ktOsjBm0oeRLt3aeC0QZa3nrMXixP7GCmJQWFPnAsQLlrpZnNRte5GB9X0wcUTUcvLo1kXzTBB5CRhSwdVQ9+/Ztc+LSiObPqFfsYY2pa85wYU6Q+Hu+aYSDrTvCzcL1ojEvUKnOmSWFYQ+fmYV7skKJL3Xr66zpWeCKyVtY8h7Ju3H3IWZTTl8Fyqtej63uHxqjQlMNzEjUL9Nzmev+O8+lCKvHXG+8dQBAYe3+tsIi1NKLSODSKxLpka52XIiNrgGnnr74YTZ8sp8Sd9STr3HUPr7uNK5I8DSL brandon@standard.ai"
      ];
    };

    nagisa = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9SSZujXXfr200aG786eyHPGZDEHTRWAZHBlXUHuCbp simonas+shirobox@standard.ai"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4h2+cyU5hfLSkGMEAhoWz6FbX2/s+YE//z/TIBsJJ6 simonas+kumabox@standard.ai"
      ];
    };

    ekleog = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpQUN+FGyX80jjYX8HZv600c8jCSmhwnC/2mCsn+j/vnm5a3Tw8La7A2LocfKpocVU7cUkZNrPsXrLFOBu3jqM3VYqRlQw6ixgwonb3klpfeUu0kPg72Q6FQHMZO+yLIKwGWYDADFwxXk/KeuZK1VgAq1GGY4AdIB+PgtJ9/63rqtd0ooBX7rfKj+mMVuahS0/wxUhDufHBjv54Kk66JsUHd3gbW6EKa6bLfUQxRbJkxDycs7OvjUmUO0ndxdnqEYMaExbM+j0AFPVEc/7TW8SDL3dXtOEmIttB8nVcja5lpGyxpRJWiAxOBaosY76P5AEvfdt/JgRFdEhcr2F7YyR ekleog@llwynog"
      ];
    };

    andi = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDg4HZ7w98KbQ6o+0YlURQSFG+3K2kVQEJTpk0RCPprjj/N/8TfLEKrqgKFEnJtvrtBBwUpXzfUBx4Qi55VfQtVTbMsLMsO41x3PU2BoybrdQroaCv/vHntCcP9FMOw4Fm5TZVWdJ4PR+VPOXNu6fmmGhiEDAqSDnlZ9IMVAsdsYqC8twY7L87Sg9LhR5gecvjYkU6XZudQQeaqT3JWlBNdWFfwNZ1HXShI6p74UjRpUmmfSo8qWm0coWOSjK7r8bTQuj5+CzzWTUP5j9JVdwfkkRgpZT+6pITtsp3xllGVbnbe5k2fMoyWfLbtuKebf2ZecBXLDaNTN1PbviaW9+M36aXlMovLcaxrR2sWHWUn1qSIVEOk4IiLS4Zpk7ldlvuIEz0Wp+w6QGt+t89DnX1vV293759mbENG70VtHpK0HW+8+aqB+Ch3IHrxwj5tRI509gSh3znkkX/C3kPduWtE0c9LQW9Qrz3lNBov2BeZOpu0UoN7HZQHtt2odcsL9IvjnjPwlqtnutc5QmJt+EzTiIAkrc6DRwjsN4eGHIzzL+LC6r0wt7MaS/R3saKYJ5XWBzKPkKgrttvOHJRBpP6tpn7zgolX92wtgOe4fRH+Wbx4Ecf+A10vbzcId57X5bFvSUqE9OgcK9fZROrwdtrO+uiRyO7YJh8OFONsu1pzGQ== cardno:000609701669"
      ];
    };

    tpflug = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEJLsCDY+XVTYMKBnVJtJmq7uDvXNZRuaaqMG1KRWSeFpeH8Uz2jWOuGgT5NCUQhafpQqwdhIIhWLLPVuBPJkoggqOc0VUh23jL71j1t285f7uRKytmN7BvoOV8o16Jiqgk1w4ugNFhgiu7hZNOIOoM7CgP855A4buzDxGM4QNTjAE2s5rmyyLsNzyL3863yccw0t3YDcvHF7hFkkJ5bGEc/aQOFo7bRFrgIGi6+EOSG7Pcx5Wh34C8mGQd8WwUQ9uQN722PINSVgxEE3WwuNqu8MjA06mwCmU4BKNB0FYm177oRkbNUWOQn4y+SFs6ajK+z6c1yNHDzwWoK80Vb5N gilligan@monoid"
      ];
    };

    cloud = {
      createHome = true;
      extraGroups = [ "lxd" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfPRiesz2VviTkRJAd3mzGRm2P+K67SutblfJ9I1+rU cloud@standard.ai"
      ];
    };
  };
}
