{ ... }: {
  imports = [
    ../core
    ../dev

    ../hardware/gce.nix
  ] ++ (import ../users).bemeurer;

  networking = {
    hostName = "sartre";
    hostId = "7ecc3d2a";
  };

  time.timeZone = "America/Los_Angeles";
}
