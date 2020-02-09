{ config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../combo/core.nix
    ../combo/dev.nix

    ../hardware/stcg-dc.nix

    ../modules/stcg-cachix.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4d662b7c-e395-49d6-86ad-237ed28eb885";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/41D0-C874";
      fsType = "vfat";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e4cdc2fd-eda2-45dd-a250-ea08a5250b9e"; } ];

  networking = {
    hostName = "cantor";
    hostId = "e387c8da";
  };

  time.timeZone = "America/Los_Angeles";

  users.users = {
    bemeurer.extraGroups = [ "docker" ];
    ogle = {
      createHome = true;
      extraGroups = [ "docker" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMbxQQ6asa917aD8HTavEinmIEsm6G3pZEOv7Rf33JCvvrdCW5ktOsjBm0oeRLt3aeC0QZa3nrMXixP7GCmJQWFPnAsQLlrpZnNRte5GB9X0wcUTUcvLo1kXzTBB5CRhSwdVQ9+/Ztc+LSiObPqFfsYY2pa85wYU6Q+Hu+aYSDrTvCzcL1ojEvUKnOmSWFYQ+fmYV7skKJL3Xr66zpWeCKyVtY8h7Ju3H3IWZTTl8Fyqtej63uHxqjQlMNzEjUL9Nzmev+O8+lCKvHXG+8dQBAYe3+tsIi1NKLSODSKxLpka52XIiNrgGnnr74YTZ8sp8Sd9STr3HUPr7uNK5I8DSL brandon@standard.ai"
      ];
    };

    cloud = {
      createHome = true;
      extraGroups = [ "docker" "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfPRiesz2VviTkRJAd3mzGRm2P+K67SutblfJ9I1+rU cloud@standard.ai"
      ];
    };
  };
}
