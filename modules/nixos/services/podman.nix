{
  environment.persistence."/nix/state".directories = [
    "/var/lib/containers"
  ];

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
