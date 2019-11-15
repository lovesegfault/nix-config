{ config, pkgs, ... }:
let
  waylandOverlayUrl =
    "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball waylandOverlayUrl));
in {
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.overlays = [ waylandOverlay ];

  boot = rec {
    consoleLogLevel = 1;
    earlyVconsoleSetup = true;
    extraModulePackages = with kernelPackages; [ acpi_call v4l2loopback ];
    kernelModules = [ "acpi_call" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "udev.log_priority=3"
      "i915.fastboot=1"
      "vga=current"
      "intel_iommu=on"
    ];
    initrd = {
      availableKernelModules = [ "nvme" "cryptd" "aes_x86_64" ];
      kernelModules = [ "i915" "aesni_intel" ];
      supportedFilesystems = [ "xfs" ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 2;
    };
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    neovim
    powertop
    qt5.qtwayland
    qgnomeplatform
    pinentry-gnome
  ];

  # Configure aspell system wide
  environment.etc."aspell.conf".text = ''
    master en_US
    extra-dicts en-computers.rws
    add-extra-dicts en_US-science.rws
  '';

  fonts = {
    fontconfig.ultimate.enable = true;
    fonts = with pkgs; [ hack-font font-awesome ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
      extraConfig = ''
        [General]
        Enable=Source,Sink,Media,Socket
      '';
    };
    bumblebee = {
      enable = true;
      connectDisplay = true;
      driver = "nvidia";
      group = "video";
      pmMethod = "bbswitch";
    };
    cpu.intel.updateMicrocode = true;
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiIntel vaapiVdpau libvdpau-va-gl ];
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      daemon.config = { realtime-scheduling = "yes"; };
    };
    u2f.enable = true;
  };

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    hostName = "wittgenstein";
    useDHCP = false;
    networkmanager = {
      enable = true;
      dhcp = "dhclient";
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
  };

  nix = {
    allowedUsers = [ "@wheel" ];
    binaryCaches = [ "https://standard.cachix.org/" ];
    binaryCachePublicKeys =
      [ "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI=" ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    gc = {
      automatic = true;
      dates = "01:00";
    };
    maxJobs = 12;
    optimise = {
      automatic = true;
      dates = [ "01:10" "12:10" ];
    };
    trustedUsers = [ "root" "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;

  programs = {
    dconf.enable = true;
    gphoto2.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    light.enable = true;
    seahorse.enable = true;
    ssh = {
      askPassword = "${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
      startAgent = false;
    };
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        alacritty
        grim
        libinput-gestures
        light
        mako
        slurp
        swaybg
        swaylock
        swayidle
        waybar
        wl-clipboard
        wf-recorder
        xwayland
      ];
      extraSessionCommands = ''
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_FORCE_DPI=physical
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true"
        export ECORE_EVAS_ENGINE=wayland_egl
        export ELM_ENGINE=wayland_egl
        export SDL_VIDEODRIVER=wayland
        export MOZ_ENABLE_WAYLAND=1
      '';
    };
    tmux = {
      enable = true;
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 10000;
      newSession = true;
      secureSocket = false;
      shortcut = "a";
      terminal = "tmux-256color";
    };
    vim.defaultEditor = true;
    zsh = {
      enable = true;
      enableGlobalCompInit = false;
    };
  };

  time.timeZone = "America/Los_Angeles";

  security = {
    audit.enable = false;
    rtkit.enable = true;
    pam.services.login = {
      enableGnomeKeyring = true;
      fprintAuth = true;
      setEnvironment = true;
    };
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    acpid.enable = true;
    fprintd.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    geoclue2.enable = true;
    gvfs.enable = true;
    gnome3 = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
      gnome-settings-daemon.enable = true;
      gnome-online-accounts.enable = true;
      gnome-online-miners.enable = true;
      tracker.enable = true;
      tracker-miners.enable = true;
      core-shell.enable = true;
    };
    nscd.enable = false;
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint cups-googlecloudprint ];
    };
    resolved = {
      enable = true;
      dnssec = "false";
      llmnr = "true";
      extraConfig = ''
        DNS=1.1.1.1 8.8.8.8 1.0.0.1 8.8.4.4 2606:4700:4700::1111 2001:4860:4860::8888 2606:4700:4700::1001 2001:4860:4860::8844
        Cache=yes
        DNSStubListener=yes
        ReadEtcHosts=yes
      '';
    };
    smartd.enable = true;
    tlp = {
      enable = true;
      extraConfig = ''
        AHCI_RUNTIME_PM_TIMEOUT=15
        CPU_BOOST_ON_AC=1
        CPU_BOOST_ON_BAT=0
        CPU_HWP_ON_AC=performance
        CPU_HWP_ON_BAT=balance_power
        CPU_MAX_PERF_ON_AC=100
        CPU_MAX_PERF_ON_BAT=50
        CPU_MIN_PERF_ON_AC=0
        CPU_MIN_PERF_ON_BAT=0
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        DEVICES_TO_DISABLE_ON_BAT=""
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth"
        DEVICES_TO_DISABLE_ON_SHUTDOWN=""
        DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"
        DEVICES_TO_ENABLE_ON_AC="bluetooth wifi wwan"
        DEVICES_TO_ENABLE_ON_SHUTDOWN="bluetooth wifi"
        DEVICES_TO_ENABLE_ON_STARTUP="wifi"
        DISK_APM_LEVEL_ON_AC="254"
        DISK_APM_LEVEL_ON_BAT="128"
        DISK_DEVICES="nvme0n1"
        DISK_IDLE_SECS_ON_AC=0
        DISK_IDLE_SECS_ON_BAT=2
        DISK_IOSCHED="mq-deadline"
        ENERGY_PERF_POLICY_ON_AC=performance
        ENERGY_PERF_POLICY_ON_BAT=power
        MAX_LOST_WORK_SECS_ON_AC=15
        MAX_LOST_WORK_SECS_ON_BAT=15
        NATACPI_ENABLE=1
        NMI_WATCHDOG=0
        PCIE_ASPM_ON_AC=performance
        PCIE_ASPM_ON_BAT=powersave
        RESTORE_DEVICE_STATE_ON_STARTUP=1
        RUNTIME_PM_DRIVER_BLACKLIST="nvidia"
        RUNTIME_PM_ON_AC=auto
        RUNTIME_PM_ON_BAT=auto
        SATA_LINKPWR_ON_AC="max_performance max_performance"
        SATA_LINKPWR_ON_BAT="min_power"
        SCHED_POWERSAVE_ON_AC=0
        SCHED_POWERSAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y
        SOUND_POWER_SAVE_ON_AC=0
        SOUND_POWER_SAVE_ON_BAT=1
        START_CHARGE_THRESH_BAT0=90
        STOP_CHARGE_THRESH_BAT0=100
        TLP_DEFAULT_MODE=AC
        TLP_ENABLE=1
        TLP_LOAD_MODULES=y
        TLP_PERSISTENT_DEFAULT=0
        TPACPI_ENABLE=1
        TPSMAPI_ENABLE=1
        USB_AUTOSUSPEND=1
        USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN=1
        USB_BLACKLIST_BTUSB=0
        USB_BLACKLIST_PHONE=1
        USB_BLACKLIST_PRINTER=0
        USB_BLACKLIST_WWAN=0
        USB_WHITELIST="1050:0407 056a:5193"
        WIFI_PWR_ON_AC=on
        WIFI_PWR_ON_BAT=on
        WOL_DISABLE=Y
      '';
    };
    undervolt = {
      enable = true;
      coreOffset = "-70";
      temp = "95";
    };
    upower.enable = true;
    xserver = {
      enable = true;
      exportConfiguration = true;
      autorun = true;
      libinput = {
        enable = true;
        accelSpeed = "0.7";
        naturalScrolling = true;
      };
      useGlamor = true;
      wacom.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
          wayland = true;
        };
        extraSessionFilePackages = [ pkgs.sway ];
      };
    };
  };

  sound.enable = true;

  system.stateVersion = "19.09";

  users.users.bemeurer = {
    createHome = true;
    description = "Bernardo Meurer";
    extraGroups = [ "camera" "input" "lxd" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  virtualisation = {
    kvmgt.enable = false;
    libvirtd.enable = false;
    lxc.enable = true;
    lxd.enable = true;
  };
}
