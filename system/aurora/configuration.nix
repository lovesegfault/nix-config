{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = rec {
    consoleLogLevel = 1;
    earlyVconsoleSetup = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "zfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        font = "${pkgs.terminus_font}/share/fonts/terminus/ter-x16n.pcf.gz";
      };
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    neovim
  ];

  # Configure aspell system wide
  environment.etc."aspell.conf".text = ''
    master en_US
    extra-dicts en-computers.rws
    add-extra-dicts en_US-science.rws
  '';

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-ocl
      ];
    };
  };

  i18n = {
    consoleFont = "ter-v16n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    hostName = "aurora";
    hostId = "9fc799ef";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.enp4s0f0.useDHCP = true;
    interfaces.enp4s0f1.useDHCP = true;
    interfaces.enp4s0f2.useDHCP = true;
    interfaces.enp4s0f3.useDHCP = true;
  };

  nix = {
    allowedUsers = [ "@wheel" ];
    binaryCaches = [ "https://standard.cachix.org/" ];
    binaryCachePublicKeys = [
      "standard.cachix.org-1:+HFtC20D1DDrZz4yCXthdaqb3p2zBimNk9Mb+FeergI="
    ];
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
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    tmux = {
      enable = true;
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;
      secureSocket = false;
      shortcut = "a";
      terminal = "tmux-256color";
    };
    vim.defaultEditor = true;
    zsh.enable = true;
  };

  time.timeZone = "America/Los_Angeles";

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    fwupd.enable = true;
    smartd.enable = true;
    upower.enable = true;
    openssh = {
      enable = true;
    };
    zfs = {
      autoScrub = {
        enable = true;
        interval = "daily";
        pools = [ "rpool" ];
      };
      autoSnapshot.enable = true;
    };
  };

  sound.enable = true;

  system.stateVersion = "19.09";

  users.users = {
    bemeurer = {
      createHome = true;
      extraGroups = [ "input" "lxd" "video" "wheel" ];
      hashedPassword =
        "***REMOVED***";
      openssh.authorizedKeys.keys = [
        "***REMOVED***"
      ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
    ekleog = {
      createHome = true;
      extraGroups = [ "input" "lxd" "video" "wheel" ];
      openssh.authorizedKeys.keys = [
      "***REMOVED***"
      ];
      isNormalUser = true;
    };
  };

  virtualisation = {
    lxc.enable = true;
    lxd.enable = true;
  };
}
