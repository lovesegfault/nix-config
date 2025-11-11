{
  lib,
  config,
  pkgs,
  utils,
  ...
}:

{
  boot = {
    initrd = {
      systemd = {
        enable = true; # Required for custom boot ordering

        # Configure systemd manager in initrd
        settings.Manager = {
          # Set shorter timeout for stop jobs to prevent hanging
          # Affects cryptsetup@credstore.service and other stop jobs
          DefaultTimeoutStopSec = "30s";
        };

        services = {
          # Disable default ZFS import service to use our custom bare import
          zfs-import-zroot.enable = false;

          # Fix ordering: create-needed-for-boot-dirs needs to wait for key loading
          create-needed-for-boot-dirs = {
            after = [ "zfs-load-key-zroot.service" ];
            requires = [ "zfs-load-key-zroot.service" ];
          };

          # Import pool bare (-N) to make zvols available before LUKS unlock
          import-zroot-bare =
            let
              # Properly escape device paths for systemd unit names
              devices = map (p: utils.escapeSystemdPath p + ".device") [
                "/dev/disk/by-id/nvme-Samsung_SSD_9100_PRO_2TB_S7YCNJ0Y506219W-part3"
              ];
            in
            {
              description = "Import zroot pool bare for credential zvol access";

              # Disable default dependencies for precise ordering control
              unitConfig.DefaultDependencies = false;

              # Wait for ZFS module, udev, and physical disks
              # After=udev ensures: startup after udev ready, shutdown before udev stops
              after = [
                "modprobe@zfs.service"
                "systemd-udevd.service"
              ]
              ++ devices;
              requires = [ "modprobe@zfs.service" ];

              # Must complete before LUKS unlock attempts (startup)
              # Must stop before cryptsetup closes during shutdown
              wants = [ "cryptsetup-pre.target" ] ++ devices;
              before = [
                "cryptsetup-pre.target"
                "systemd-cryptsetup@credstore.service"
              ];
              conflicts = [ "initrd-switch-root.target" ];

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                # Note: Pool is NOT exported - real root is on this pool!
                # Pool stays imported for the running system to use
              };

              path = [ config.boot.zfs.package ];

              script = ''
                # Export pool on failure to avoid bad state
                function cleanup() {
                  exit_code=$?
                  if [ "$exit_code" != 0 ]; then
                    zpool export zroot 2>/dev/null || true
                  fi
                }
                trap cleanup EXIT

                # Import without mounting (-N flag)
                # Use -f to force import (pool may show as in-use from install environment)
                zpool import -N -f zroot

                # Validate encryption root for security
                encroot="$(zfs get -H -o value encryptionroot zroot/local)"
                if [ "$encroot" != "zroot/local" ]; then
                  echo "ERROR: zroot/local has invalid encryptionroot $encroot" >&2
                  exit 1
                fi

                echo "Successfully imported zroot pool (bare mode)"
              '';
            };
          # Load ZFS encryption key from TPM2-backed credential store
          zfs-load-key-zroot = {
            description = "Load ZFS encryption key from TPM2-backed credential store";

            unitConfig = {
              DefaultDependencies = false;
              RequiresMountsFor = "/etc/credstore";
              StopWhenUnneeded = true;
            };

            # Must wait for both pool import and credstore mount
            requires = [ "import-zroot-bare.service" ];
            after = [
              "import-zroot-bare.service"
              "etc-credstore.mount"
            ];

            # Must complete before mounting root
            before = [
              "sysroot.mount"
              "initrd.target"
            ];
            requiredBy = [ "initrd.target" ];

            # Ensure this service stops before we try to unmount credstore
            conflicts = [ "initrd-switch-root.target" ];

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              # Use systemd credentials for secure key access
              ImportCredential = "zfs-sysroot.mount";
            };

            path = [ config.boot.zfs.package ];

            script = ''
              # Load key from credential directory (automatically decrypted by systemd)
              zfs load-key -L file://"''${CREDENTIALS_DIRECTORY}"/zfs-sysroot.mount zroot/local
              echo "Successfully loaded ZFS encryption key"
            '';
          };
          # Rollback root filesystem to pristine state (impermanence)
          rollback = {
            description = "Rollback root filesystem to pristine state on boot";

            wantedBy = [ "initrd.target" ];

            # Must wait for ZFS key to be loaded
            requires = [ "zfs-load-key-zroot.service" ];
            after = [ "zfs-load-key-zroot.service" ];
            before = [ "sysroot.mount" ];

            path = [ config.boot.zfs.package ];

            unitConfig.DefaultDependencies = false;

            serviceConfig.Type = "oneshot";

            script = ''
              zfs rollback -r zroot/local/root@blank && \
                echo "  >> >> rollback complete << <<"
            '';
          };
        };

        # Explicitly define credstore mount unit (not via fstab)
        mounts = [
          {
            where = "/etc/credstore";
            what = "/dev/mapper/credstore";
            type = "ext4";
            options = "defaults";
            wantedBy = [ "initrd-fs.target" ];
            after = [
              "systemd-cryptsetup@credstore.service"
              "systemd-udevd.service" # After udev during startup, before udev during shutdown
            ];
            requires = [ "systemd-cryptsetup@credstore.service" ];
            before = [ "initrd-switch-root.target" ];
            conflicts = [ "initrd-switch-root.target" ];
            # Note: Requires relationship already ensures mount stops before cryptsetup during shutdown
            unitConfig.DefaultDependencies = false;
          }
        ];

        # Manage shutdown conflicts to prevent hanging
        # Stop and unmount credstore before switching to real root
        targets.initrd-switch-root = {
          conflicts = [
            "etc-credstore.mount"
            "systemd-cryptsetup@credstore.service"
          ];
          # Wait for these to stop before proceeding
          after = [
            "etc-credstore.mount"
            "systemd-cryptsetup@credstore.service"
          ];
        };
      };

      # Configure TPM2-backed LUKS device for credential store
      luks.devices.credstore = {
        device = "/dev/zvol/zroot/credstore";
        # TPM2 automatic unlock with PCR binding
        # PCR 7: Secure Boot state - prevents unlock if Secure Boot disabled
        # PCR 15: System identity - extended by tpm2-measure-pcr after unlock
        #         Prevents decryption outside initrd (oddlama attack mitigation)
        #         After first unlock, PCR 15 ≠ initial state → TPM refuses subsequent unlocks
        crypttabExtraOpts = [
          "tpm2-device=auto" # Use available TPM2 device
          "tpm2-measure-pcr=yes" # Extends PCR 15 AFTER unlock (makes key unusable for re-unlock)
          "tpm2-pcrs=7+15" # Bind to Secure Boot state + initrd-only enforcement
          "x-initrd.attach" # Mark as initrd-only device
          # Note: After rebuild, re-enroll with: systemd-cryptenroll /dev/zvol/zroot/credstore --tpm2-device=auto --tpm2-pcrs=7+15
        ];
      };

      # Support ext4 filesystem for credential store
      supportedFilesystems = [ "ext4" ];

      # Add TPM kernel modules
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "sd_mod"
        "tpm_tis" # TPM Interface Specification (x86)
        "tpm_crb" # Command Response Buffer (modern)
      ];
    };

    # TEMPORARY: Enable for debugging hung stop job
    kernelParams = [
      "rd.systemd.debug_shell"
      "systemd.log_level=debug"
      # "systemd.log_target=console"
    ];
    initrd.systemd.emergencyAccess = true;
  };

  # Add TPM2 tools for manual enrollment and testing
  environment.systemPackages = with pkgs; [
    tpm2-tss
    tpm2-tools
  ];
}
