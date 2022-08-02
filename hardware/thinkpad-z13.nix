{ nixos-hardware, pkgs, ... }: {
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-pc-laptop-ssd
    ./bluetooth.nix
    ./efi.nix
    ./sound-pipewire.nix
  ];

  boot = rec {
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
  };

  nix.settings = {
    max-jobs = 16;
    system-features = [
      "benchmark"
      "nixos-test"
      "big-parallel"
      "kvm"
      "gccarch-znver3"
    ];
  };

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    xserver.dpi = 96;
  };
}
