{ pkgs, lib, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
    ./nouveau.nix
    ./sound.nix
  ];

  boot = rec {
    extraModulePackages = with kernelPackages; [ ddcci-driver ];
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernel.sysctl = { "vm.swappiness" = 1; };
    kernelModules = [ "kvm-intel" "i2c_dev" "ddcci-backlight" "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [
      {
        name = "runpm-fixes";
        patch = (pkgs.fetchpatch {
          url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=23ee3e4e5bd27bdbc0f1785eef7209ce872794c7";
          sha256 = "048l3rk59wbw165280h6zcjjdd7ckmhimcbszjk10c6sg55bxzmx";
        });
      }
      # FIXME: Remove this when kernel 5.8 is out
      {
        name = "thinkpad-dual-fan-ctrl";
        patch = (pkgs.fetchpatch {
          url = "http://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git/patch/14232c6e788cb1f7b96dbd08b077f90923324b24?hp=4a65ed6562bcfa58fe0c2ca5855c45268f40d365";
          sha256 = "1bp7hg4ppwiyp0bvhijhqr2gcz79g1lv22fyq3bb8rbcwziszxa6";
        });
      }
    ];
    kernelParams = [ "psmouse.synaptics_intertouch=1" ];
  };

  console = {
    font = "ter-v28n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment.systemPackages = with pkgs; [ powertop ];

  hardware = {
    brillo.enable = true;
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  nix = {
    maxJobs = 12;
    systemFeatures = [ "benchmark" "nixos-test" "big-parallel" "kvm" "gccarch-skylake" ];
  };

  nixpkgs = {
    overlays = [ (import ../overlays/march-skylake.nix) ];
    localSystem = {
      system = "x86_64-linux";
      platform = lib.systems.platforms.pc64 // {
        gcc.arch = "skylake";
        gcc.tune = "skylake";
      };
    };
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    tlp = {
      enable = true;
      extraConfig = ''
        CPU_ENERGY_PERF_POLICY_ON_AC=performance
        CPU_ENERGY_PERF_POLICY_ON_BAT=power
        CPU_MAX_PERF_ON_AC=100
        CPU_MAX_PERF_ON_BAT=50
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth wifi"
        DEVICES_TO_ENABLE_ON_AC="bluetooth wifi"

        DISK_APM_LEVEL_ON_AC="255 254"
        DISK_APM_LEVEL_ON_BAT="128 1"
        DISK_DEVICES="nvme0n1 sda"
        DISK_IOSCHED="none bfq"

        MAX_LOST_WORK_SECS_ON_AC=15
        MAX_LOST_WORK_SECS_ON_BAT=15

        RUNTIME_PM_ON_AC=auto
        RUNTIME_PM_ON_BAT=auto
        RUNTIME_PM_DRIVER_BLACKLIST="amdgpu nouveau nvidia radeon"

        SOUND_POWER_SAVE_ON_AC=1
        SOUND_POWER_SAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y

        #              sd-card   yubikey   wacom
        USB_WHITELIST="0bda:0328 1050:0407 056a:5193"
      '';
    };

    # block my dumb sd-card reader that chugs power from coming on
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0328", ATTR{authorized}="0"
    '';
    xserver.dpi = 96;
  };

  sound.extraConfig = ''
    options snd-hda-intel model=generic
  '';
}
