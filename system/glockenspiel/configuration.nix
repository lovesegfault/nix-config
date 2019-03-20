# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports = [./hardware-configuration.nix];

# Boot
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.enable = true;
	boot.supportedFilesystems = [ "zfs" ];

# Internationalization
	i18n = {
		consoleFont = "ter-v12n";
		consoleKeyMap = "uk";
		defaultLocale = "en_US.UTF-8";
	};

# Time
	time.timeZone = "America/Los_Angeles";

# Environment
	environment.systemPackages = with pkgs; [
		terminus_font
		thermald
		vim
		wireguard
		wireguard-tools
	];
# Programs
    programs.zsh.enable = true;
# Security
	security.sudo.enable = true;
	security.sudo.wheelNeedsPassword = false;

# Services
	services.dbus.packages = with pkgs; [ gnome3.dconf ];
	services.logind.lidSwitch = "ignore";
	services.openssh.enable = true;

# Networking
	networking.domain = "worknet";
	networking.hostId = "e39bffc0";
	networking.hostName = "glockenspiel";
	networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    networking.nftables = {
        enable = true;
        ruleset = ''
          table inet filter {
            chain input {
              type filter hook input priority 0; policy drop;
              # Drop Invalid connections
              ct state invalid drop
              # Always accept loopback interface
              iif "lo" accept
              # Block ping floods
              ip protocol icmp icmp type echo-request limit rate over 10/second burst 4 packets  drop
              ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate over 10/second burst 4 packets drop
              # Accept established/related connections
              ct state established,related accept
              # ICMP
              ip6 nexthdr icmpv6 icmpv6 type {
                destination-unreachable,
                packet-too-big,
                time-exceeded,
                parameter-problem,
                mld-listener-query,
                mld-listener-report,
                mld-listener-reduction,
                nd-router-solicit,
                nd-router-advert,
                nd-neighbor-solicit,
                nd-neighbor-advert,
                ind-neighbor-solicit,
                ind-neighbor-advert,
                mld2-listener-report
              } accept
              ip protocol icmp icmp type {
                echo-request,
                destination-unreachable,
                router-solicitation,
                router-advertisement,
                time-exceeded,
                parameter-problem
              } accept
              # IGPM
              ip protocol igmp accept
              # UDP
              ip protocol udp ct state new jump UDP
              ip protocol udp reject
              # TCP
              ip protocol tcp tcp flags & (fin | syn | rst | ack) == syn ct state new jump TCP
              ip protocol tcp reject with tcp reset
              meta nfproto ipv4 counter packets 1 bytes 32 reject with icmp type prot-unreachable
            }
            chain forward {
              type filter hook forward priority 0; policy drop;
            }
            chain output {
              type filter hook output priority 0; policy accept;
            }
            chain TCP {
              tcp dport ssh ct state new limit rate 15/minute accept
            }
            chain UDP {
              # udp dport 60000-61000 log prefix "MOSH: " accept
              udp sport 3956 ct state new limit rate 100/second log prefix "GVCP: " accept
            }
          }
        '';
    };
# Nix
	nix.gc.automatic = true;
	nix.gc.dates = "06:00";
	nix.gc.options = "--delete-older-than 3d";

# Users
	users.users.bemeurer = {
		description = "Bernardo Meurer";
		extraGroups = [ "wheel" "networkmanager" "systemd-journal" ];
		home = "/home/bemeurer";
		isNormalUser = true;
		openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXXyPGzUk99poQMPIy0ObVcXSNr0szPoShTrJxDcV4GPqxV3vcUZc/15+PosOY5a0HOBMHEeUfne0zOO9Rs6PIMmzPZax/3sAlkU9f9NEuaS7r0SAnoFqSYff70BsF5PXIo5QDllHeAzJxsPkYzjUbeYnRTHz/tXoLlOiqlR9hwTT8GoO5sYx7J1kST/EK2RoC76bAla1WR8H2oWh2E4Gs8PDwN+/VUjCJDKHBjEfULRFhVzQfhsaLG5UEsOflV9Kc4VebIVmSRwbQ5uQSC3yN/sTZyng6TZvNJSbf1KNFoEdvEmgfb66YFUwSI1U55xkn1A91TFPfju1YF/PXbjD4D5JbhTT22Veu5FzBlS+/pnTtQifooGDqRXdpQiP2SdQchbsSNcN/6cF3FcgY02TrtCVp+N20hCiMXm/ToFqifC4cxunllRTAanQlbf0d7tVFThyJWAf5LssHmYNNQv+M9/3uvt5bxzr0BoErlRBP8JKKp0ygCLkhphCHYBh4QTkpm5nS42cMuuYcuRmkIpKQok48vqJHigwKYnSoh/esNdanGYpaRnPDfkeM0FYGXQ5CijXbzCo3fq4sUsmISnTfhtMzFS65IeEBhfhXx1NDPF+nbZG3s++Bd+kONJVBqrUhG4I3S+Czw8Fz3OkTI6RpIPnm9aXzY4SYlmXeMWXkQw== personal"];
        shell = pkgs.zsh;
        uid = 1000;
	};

# This value determines the NixOS release with which your system is to be
# compatible, in order to avoid breaking some software such as database
# servers. You should change this only after NixOS release notes say you
# should.
	system.stateVersion = "18.09";

}
