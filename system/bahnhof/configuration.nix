{ config, pkgs, ... }:

{
  boot = {
    consoleLogLevel = 1;
    earlyVconsoleSetup = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "cma=32M" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  swapDevices = [{
    device = "/swapfile";
    size = 2048;
  }];

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
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    pulseaudio.enable = true;
  };

  i18n = {
    consoleFont = "ter-v16n";
    consoleKeyMap = "us";
    consolePackages = with pkgs; [ terminus_font ];
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    hostName = "bahnhof";
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
      # wifi.backend = "iwd";
    };
  };

  nix = {
    allowedUsers = [ "@wheel" ];
    daemonIONiceLevel = 5;
    daemonNiceLevel = 10;
    gc = {
      automatic = true;
      dates = "01:00";
    };
    maxJobs = 4;
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
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      permitRootLogin = "yes";
      ports = [ 22 55888 ];
    };

    # resolved = {
    #   enable = true;
    #   dnssec = "false";
    #   llmnr = "true";
    #   extraConfig = ''
    #     DNS=1.1.1.1 8.8.8.8 1.0.0.1 8.8.4.4 2606:4700:4700::1111 2001:4860:4860::8888 2606:4700:4700::1001 2001:4860:4860::8844
    #     Cache=yes
    #     DNSStubListener=yes
    #     ReadEtcHosts=yes
    #   '';
    # };
  };

  sound.enable = true;

  system.stateVersion = "19.09";

  users.users.bemeurer = {
    createHome = true;
    extraGroups = [ "wheel" ];
    hashedPassword =
      "***REMOVED***";
    isNormalUser = true;
    # shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSuKKONpK7Ul0wXTqmbWgJ/Z4Zl1qYg/OrDPitjp8p8CkkLj4IQI4+DGPLe05aw694Vsq40wFmChWVitMF+0OEwYZD5P0Wp0hkCSACcfILdkCCrTDXO8GBogaWkWaGuoPCsHTPB741Hq6IEumFVEySrNy3EFA+4zHBXZHFgYuu4gNtdakOUEh0s1yRnK9UiQhvbTTMAq9kC7pVlx5bRAYNOe3noXuy8D6AnYEs+4rACZ65qvcFyfTjQaC7ADZ5dsKCQBeaKra+dRU5fUH8lJ7BJ5ery1Y/6wDtaOEv21xk3KhmMGYaZy15adHJPxK6PGbPfiy3xVKa6VP5r+DcqgiOx6y8ieMuOxD3tk/GNag2e6bggaZNxUaXghrj57TsJL9zJHy7dJVEGOHN/Wi6MmOcl0UTz4rZoilVdb6NxrU17Ehi+vFCKJXXcKMAeVz16rl1MTWdqSFVYwXEuywQaNiRD2WcWLSE+lWkmznDabJV3ymj5lKJcQvot+I27N72c9zbF4lKfG1kLr+ve0wU9A5vJzRiKl78qqFNGf45Vqfx890ALBiqec9i0at6pxya8C84LiPFqlXyPzkxwJamRuusVU5LxqogrbT7QOpSgjwHCIeQ9uRywP9QSND2oVV20TAAZPF/V2WLH+B7rgaBsb/fGvAaWC5q5V6E0XgolDeAWw== bemeurer@bergman"
    ];
  };
}
