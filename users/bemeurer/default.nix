{ config, hostType, lib, ... }: {
  imports = [ ]
    ++ lib.optional (hostType == "nixos") ./nixos.nix
    ++ lib.optional (hostType == "darwin") ./darwin.nix
  ;


  home-manager.users.bemeurer = {
    imports = [ ./home-manager.nix ];

    home.username = config.users.users.bemeurer.name;
    home.uid = config.users.users.bemeurer.uid;
  };
}
