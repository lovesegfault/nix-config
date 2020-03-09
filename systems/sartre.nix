{ ... }: {
  imports = [
    (import ../users).bemeurer
    ../core
    ../dev

    ../hardware/gce.nix
  ];

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  time.timeZone = "America/Los_Angeles";
}
