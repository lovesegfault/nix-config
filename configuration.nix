{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    "./machines/${networking.hostName}.nix"
  ];

  networking.hostName = "wittgenstein";
}
