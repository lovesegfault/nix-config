{ config, lib, pkgs, ... }:
with lib;
rec {
  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "wheel" ]
      ++ optionals config.sound.enable [ "audio" ]
      ++ optionals config.programs.sway.enable [ "input" "video" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2 bemeurer.personal"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFAvxz7tBCov9310ucqrVeAS0aSWCVh5sSsLjH/62lIldFPd7JVK5y+f5VETycoRy9aQSzzlb4wsXtCX0WMtRx8tWbeV4MVXHSDROQEI1QpWM5BPgrLdNB5zR+czjSb0It+3XrzzOiu1RaIY/48EEhxxshghLEVQqwHplObQI9yzdxfVPD9ZOqbxQRi6hYm9uEU3DcAONhLDAIlaDltmZVr7Vfg3P+eucO+QJ7/aLuochWLxLX/NjBsihYLrZIY+y1JAP2jm+dkGVTimozr/zwopO4y4+FlLK71ZbE1xlLX/UZHdfN00rmmZwzeTN+S7+H3cQSCQO6p6qmk9fT94sr9S7pKa8/fSr/1q7wbvKcoOW0hYal4XHnuON58+kA7thgZgFEji6o9KqWsss1wqx/XLYu2ThU6OpplPzhL+AwaH1uQpmoQ5ge29Emadv42R1jw0js2nljA4sJFybFmV0LJwORvqjaYuEj2peS40BT3eI+51plD85p//gmTeT3W7zqR8KB5bWK1xzWReSOI0Vg6PGiBPSA38dH5V7OZXDjZRnlE1WTD3E7MVKGhQDwQHoQdAvNSG7LyBfK7eprCTQAR/LkTaIQrCxLsIkzoSor5ZkG6P+QWN+HaN9YFJT6p7TtHbzZqpRkKAcVkNwXcGOyIw4ofybmUUEQ8O5Y8CC9Fw== cardno:000610250089"
    ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    uid = 8888;
    hashedPassword = "$6$rounds=65536$iIIt7MZ7K0ghK$HMPPLFtp7SpvpLAajlgZp.sH2rCNsOq41E1CDCGCaxyz/tXSqWngalatM0V5zsMbj/4klKdAzeoOw1rZj7fp6/";
  };

  secrets.files.beets-config = pkgs.mkSecret {
    file = ../../secrets/beets-config.yaml;
    user = "bemeurer";
  };

  home-manager.users.bemeurer = mkMerge [
    { imports = [ ./core ./dev ]; }
    (mkIf config.programs.sway.enable {
      imports = [ ./trusted ./sway ./music ];
      xdg.configFile."beets/config.yaml".source = secrets.files.beets-config.file;
    }
    )
  ];
}
