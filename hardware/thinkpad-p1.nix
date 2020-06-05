{ pkgs, lib, ... }: {
  imports = [
    ./bluetooth.nix
    ./efi.nix
    ./intel.nix
    ./nouveau.nix
  ];

  boot = rec {
    extraModulePackages = with kernelPackages; [ ddcci-driver ];
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernel.sysctl = {
      "fs.file-max" = 1048576;
      "net.core.default_qdisc" = "cake";
      "net.core.netdev_max_backlog" = 65536;
      "net.core.optmem_max" = 25165824;
      "net.core.somaxconn" = 4096;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_fin_timeout" = 15;
      "net.ipv4.tcp_max_tw_buckets" = 1440000;
      "net.ipv4.tcp_mem" = "65536 131072 262144";
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_rmem" = "8192 87380 16777216";
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_synack_retries" = 2;
      "net.ipv4.tcp_tw_recycle" = 1;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_wmem" = "8192 65536 16777216";
      "net.ipv4.udp_mem" = "65536 131072 262144";
      "net.ipv4.udp_rmem_min" = 16384;
      "net.ipv4.udp_wmem_min" = "16384";
      "vm.dirty_background_bytes" = 4194304;
      "vm.dirty_bytes" = 4194304;
      "vm.max_map_count" = 1048576;
      "vm.swappiness" = 1;
    };
    kernelModules = [ "kvm-intel" "i2c_dev" "ddcci-backlight" "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages;
    kernelPatches = [
      {
        # FIXME: Remove this when kernel 5.8 is out
        name = "thinkpad-dual-fan-ctrl";
        patch = (
          pkgs.fetchpatch {
            url = "http://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git/patch/14232c6e788cb1f7b96dbd08b077f90923324b24?hp=4a65ed6562bcfa58fe0c2ca5855c45268f40d365";
            sha256 = "1bp7hg4ppwiyp0bvhijhqr2gcz79g1lv22fyq3bb8rbcwziszxa6";
          }
        );
      }
    ];
    kernelParams = [
      # more dmesg
      "log_buf_len=5M"
      # i don't know, the kernle complains
      "psmouse.synaptics_intertouch=1"
      # force iwlwifi power saving on
      "iwlwifi.power_save=Y"
      "iwldvm.force_cam=N"
    ];
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
    #udev.extraRules = ''
    #  SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0328", ATTR{authorized}="0"
    #'';
    xserver.dpi = 96;
  };
}
