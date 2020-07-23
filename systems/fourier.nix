{ config, lib, pkgs, ... }: {
  imports = [
    (import ../nix).impermanence-sys
    (import ../nix).musnix
    ../core

    ../dev

    ../hardware/efi.nix
    ../hardware/nouveau.nix
    ../hardware/sound.nix
    ../hardware/zfs.nix

    ../users/bemeurer
  ];

  boot = {
    blacklistedKernelModules = [ "r8169" "snd_hda_intel" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
    kernel.sysctl."vm.swappiness" = lib.mkForce 1;
    extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
    kernelModules = [ "kvm-amd" "r8125" ];
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.noXlibs = true;

  environment.persistence."/nix/state" = {
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixus-secrets"
      "/var/lib/roon-server"
      "/var/log"
    ] ++ [
      "/home/bemeurer/.cache/zsh"
      "/home/bemeurer/.local/share/bash"
      "/home/bemeurer/.local/share/nvim"
      "/home/bemeurer/.local/share/zsh"
      "/home/bemeurer/.ssh"
      "/home/bemeurer/src"
      "/home/bemeurer/tmp"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "size=20%" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E954-11BC";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/b192a21f-08ae-4ce9-ac41-053854fc52c9";
      fsType = "xfs";
      neededForBoot = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = lib.mkForce false;
  };

  home-manager.verbose = true;
  home-manager.users.bemeurer = { ... }: {
    imports = [ (import ../nix).impermanence-home ];
    home.persistence."/nix/state/home/bemeurer".files = [
      ".gist"
      ".gist-vim"
      ".newsboat/cache.db"
      ".newsboat/history.search"
    ];
  };

  musnix = {
    enable = true;
    kernel = {
      optimize = true;
      realtime = true;
    };
  };

  networking = {
    hostName = "fourier";
    hostId = "80f4ef89";
    wireless.iwd.enable = true;
  };

  nix = {
    maxJobs = 16;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" ];
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
    { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
    { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
  ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    roon-server = {
      enable = true;
      openFirewall = true;
    };
  };
  systemd.services.roon-server.serviceConfig.ExecStart = lib.mkForce "${pkgs.roon-server}/start.sh";

  sound.extraConfig = ''
    defaults.pcm.!card "Modius";
    defaults.ctl.!card "Modius";
  '';

  systemd.network = {
    networks = {
      lan = {
        DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
        matchConfig.MACAddress = "18:c0:4d:31:0c:5f";
      };
      wifi = {
        DHCP = "yes";
        matchConfig.MACAddress = "a8:7e:ea:cb:96:cf";
      };
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/6075a47d-006a-4dbb-9f86-671955132e2f"; }];

  time.timeZone = "America/Los_Angeles";
}
