{ flake, pkgs, ... }:
let
  inherit (flake) inputs self;
in
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-laptop-ssd
    ])
    ++ (with self.nixosModules; [
      hardware-bluetooth
      hardware-efi
      hardware-sound
    ]);

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "thinkpad_acpi"
      "thunderbolt"
      "xhci_pci"
    ];
    blacklistedKernelModules = [ "sp5100_tco" ];
    kernelModules = [
      "kvm-amd"
      "thinkpad_acpi"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nowatchdog"
      "amd_prefcore=enable"
      "preempt=full"
    ];
    tmp.useTmpfs = true;
  };

  console = {
    font = "ter-v24n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [ iw ];
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;
    graphics.enable = true;
  };

  nix.settings.system-features = [
    "benchmark"
    "nixos-test"
    "big-parallel"
    "kvm"
    "gccarch-znver3"
  ];

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = [
          "bluetooth"
          "wifi"
        ];
        DEVICES_TO_ENABLE_ON_AC = [
          "bluetooth"
          "wifi"
        ];

        DISK_IOSCHED = [ "none" ];

        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };
    xserver.dpi = 250;
  };

  systemd = {
    services.ath11k_hibernate = {
      description = "load/unload ath11k to prevent hibernation issues";
      before = [
        "hibernate.target"
        "suspend-then-hibernate.target"
        "hybrid-sleep.target"
      ];
      unitConfig.StopWhenUnneeded = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "-${pkgs.kmod}/bin/modprobe -a -r ath11k_pci ath11k";
        ExecStop = "-${pkgs.kmod}/bin/modprobe -a ath11k_pci ath11k";
      };
      wantedBy = [
        "hibernate.target"
        "suspend-then-hibernate.target"
        "hybrid-sleep.target"
      ];
    };
    sleep.extraConfig = ''
      HibernateMode=shutdown
    '';
    tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];
  };
}
