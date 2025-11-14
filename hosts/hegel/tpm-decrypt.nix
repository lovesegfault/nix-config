{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
# TPM2-Based ZFS Auto-Unlock for ${poolName}
#
# This implements automatic ZFS pool unlocking using TPM2 with passphrase fallback.
# The credstore (credential store) zvol contains the ZFS encryption key and is
# automatically unlocked via TPM2 during boot.
#
# ============================================================================
# ARCHITECTURE
# ============================================================================
#
# Boot Sequence:
#   1. modprobe@zfs.service           - Load ZFS kernel module
#   2. systemd-udevd.service          - Device management (settles before cryptsetup)
#   3. import-zroot-bare.service      - zpool import -N zroot (bare mode)
#   4. cryptsetup-pre.target          - Synchronization point
#   5. systemd-cryptsetup@credstore   - TPM2 auto-unlock LUKS zvol
#   6. etc-credstore.mount            - Mount credential filesystem
#   7. zfs-load-key-zroot.service     - Load ZFS key from credstore
#   8. rollback.service               - Impermanence rollback
#   9. sysroot.mount                  - Mount root filesystem
#
# Components:
#   - credstore zvol: 100M unencrypted ZFS volume with TPM2-backed LUKS encryption
#   - TPM2 binding: PCR 7 (Secure Boot) + PCR 15 (initrd-only)
#   - Systemd credentials: Secure key injection using ImportCredential
#   - Bare pool import: zpool import -N makes zvols available before mounting
#
# ============================================================================
# KEY TECHNIQUES (from discourse thread)
# https://discourse.nixos.org/t/import-zpool-before-luks-with-systemd-on-boot/65400
# ============================================================================
#
#   - zpool import -N: Import pool without mounting datasets
#   - DefaultDependencies = false: Precise service ordering control
#   - After=systemd-udevd: Ensures device operations complete before udev stops
#   - systemd-udevd.before=cryptsetup: Ensures udev settles before unlock
#   - ImportCredential: Secure key injection between services
#   - Conflicts with initrd-switch-root: Clean shutdown
#
# ============================================================================
# SECURITY MODEL
# ============================================================================
#
# PCR 7: Secure Boot Enforcement
#   - Credstore only unlocks when Secure Boot is enabled
#   - Prevents boot chain tampering
#
# PCR 15: Initrd-Only Decryption (oddlama attack mitigation)
#   - TPM seals key to PCR 15 in initial (zeroed) state
#   - tpm2-measure-pcr extends PCR 15 AFTER first unlock
#   - Once extended, PCR 15 ≠ initial state → TPM refuses subsequent unlocks
#   - Result: Credstore accessible only during initrd, never after
#   - Prevents attacks where root user on running system decrypts credstore
#
# Fallback: LUKS passphrase prompt if TPM2 fails
#
# What TPM2 Protects Against:
#   - Offline disk theft (key sealed to hardware)
#   - Boot tampering (PCR measurements)
#   - Evil maid attacks (boot chain validation)
#   - Oddlama-style attacks (initrd-only decryption)
#
# What TPM2 Does NOT Protect Against:
#   - Physical hardware attacks with sophisticated tools
#   - Cold boot attacks (memory retention)
#   - Bootkit before Secure Boot
#
# ============================================================================
# POST-INSTALLATION SETUP
# ============================================================================
#
# After deploying this configuration:
#
# 1. Verify TPM2 Hardware:
#    ls -la /dev/tpm*            # Should show /dev/tpm0 or /dev/tpmrm0
#    tpm2_getcap properties-fixed
#
# 2. Enroll TPM2 Key (CRITICAL - Note the explicit PCR 15 value):
#    sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
#      --tpm2-device=auto \
#      --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
#
#    WHY explicit PCR 15 value?
#    - PCR 15 starts at 0x0000... (zeroed) at boot
#    - After unlock, tpm2-measure-pcr extends PCR 15 to non-zero
#    - If enrolling from running system, PCR 15 is already extended
#    - Must explicitly set to zeros so TPM expects boot-time state
#    - Otherwise unlock will fail (PCR mismatch)
#
# 3. Verify Enrollment:
#    sudo cryptsetup luksDump /dev/zvol/zroot/credstore
#    # Should show systemd-tpm2 token with PCRs 7,15
#
# 4. Test:
#    sudo reboot
#    # Should boot automatically without password prompt
#
# 5. Verify PCR 15 Protection:
#    tpm2_pcrread sha256:15
#    # Should show non-zero value (extended after unlock)
#    sudo cryptsetup luksOpen /dev/zvol/zroot/credstore test
#    # Should fail - TPM refuses to unseal outside initrd
#
# ============================================================================
# RE-ENROLLMENT AFTER UPDATES
# ============================================================================
#
# When to re-enroll:
#   - Firmware/BIOS updates
#   - Secure Boot policy changes
#   - After PCR-affecting system changes
#
# How to re-enroll:
#   1. Boot with passphrase (TPM2 will fail, fallback works)
#   2. sudo systemd-cryptenroll /dev/zvol/zroot/credstore --wipe-slot=tpm2
#   3. sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
#        --tpm2-device=auto \
#        --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
#   4. Reboot to test
#
# ============================================================================
# TROUBLESHOOTING
# ============================================================================
#
# System won't boot (hangs at "Waiting for credstore"):
#   - Enter LUKS passphrase when prompted
#   - Check logs: journalctl -u systemd-cryptsetup@credstore.service
#   - Re-enroll TPM2 if needed
#
# ZFS key load fails:
#   - Boot to emergency shell (enable emergencyAccess below)
#   - Check: mount | grep credstore
#   - Check: ls -la /etc/credstore/zfs-sysroot.mount
#   - Manual: zfs load-key -L file:///etc/credstore/zfs-sysroot.mount zroot/local
#
# Debug boot issues:
#   - Temporarily enable debug options below (see WARNING)
#   - Emergency shell on tty9 (Ctrl+Alt+F9)
#   - After debugging, DISABLE and rebuild (security risk!)
#
# ============================================================================
# DISKO STRUCTURE REQUIREMENTS
# ============================================================================
#
# This module requires the following disko structure:
#   - Exactly ONE zpool containing a credstore zvol
#   - Credstore must be: type=zfs_volume, content.type=luks
#   - At least ONE encrypted dataset (zfs_fs with encryption option)
#   - Encrypted dataset keylocation must use file:// URI (mount point derived from path)
#
# ============================================================================
# CONFIGURATION
# ============================================================================
let
  # Discover which zpool contains the credstore zvol for TPM2 unlock
  diskoConfig = config.disko.devices;

  poolsWithCredstore = lib.filterAttrs (
    _poolName: pool:
    lib.any (
      dsName:
      let
        ds = pool.datasets.${dsName};
      in
      ds.type or "" == "zfs_volume" && ds.content.type or "" == "luks"
    ) (builtins.attrNames pool.datasets)
  ) (diskoConfig.zpool or { });

  poolNames = builtins.attrNames poolsWithCredstore;

  # Assert exactly one pool has credstore
  poolName =
    lib.throwIf (builtins.length poolNames == 0)
      "tpm-decrypt.nix: No zpool found with credstore zvol (zfs_volume with luks content)"
      (
        lib.throwIf (builtins.length poolNames > 1)
          "tpm-decrypt.nix: Found ${toString (builtins.length poolNames)} pools with credstore, expected exactly 1: ${lib.concatStringsSep ", " poolNames}"
          (builtins.head poolNames)
      );

  poolConfig = poolsWithCredstore.${poolName};

  # Find the credstore dataset
  credstoreDatasetName = lib.findFirst (
    dsName:
    let
      ds = poolConfig.datasets.${dsName};
    in
    ds.type or "" == "zfs_volume" && ds.content.type or "" == "luks"
  ) (throw "No credstore zvol found in pool ${poolName}") (builtins.attrNames poolConfig.datasets);

  credstoreConfig = poolConfig.datasets.${credstoreDatasetName};
  credstoreLuksName = credstoreConfig.content.name;

  # Find the encrypted parent dataset
  encryptedDatasetName = lib.findFirst (
    dsName:
    let
      ds = poolConfig.datasets.${dsName};
    in
    ds.type or "" == "zfs_fs" && (ds.options.encryption or "") != ""
  ) (throw "No encrypted dataset found in pool ${poolName}") (builtins.attrNames poolConfig.datasets);

  encryptedDataset = "${poolName}/${encryptedDatasetName}";

  # Extract mount point and credential file name from keylocation
  # Example: "file:///etc/credstore/zfs-sysroot.mount" → mountpoint="/etc/credstore", filename="zfs-sysroot.mount"
  keylocation = poolConfig.datasets.${encryptedDatasetName}.options.keylocation or "";

  keylocationPath =
    lib.throwIf (!(lib.hasPrefix "file://" keylocation))
      "Encrypted dataset keylocation must start with 'file://', found: ${keylocation}"
      (lib.removePrefix "file://" keylocation);

  credstoreMountpoint = dirOf keylocationPath;
  credentialFileName = baseNameOf keylocationPath;

  # Find disk containing the pool
  diskName = lib.findFirst (
    dName:
    let
      disk = diskoConfig.disk.${dName};
    in
    lib.any (
      partName:
      let
        part = disk.content.partitions.${partName};
      in
      part.content.type or "" == "zfs" && part.content.pool or "" == poolName
    ) (builtins.attrNames (disk.content.partitions or { }))
  ) (throw "No disk found containing pool ${poolName}") (builtins.attrNames diskoConfig.disk);

  diskConfig = diskoConfig.disk.${diskName};

  # Find ZFS partition name
  zfsPartName =
    lib.findFirst
      (
        partName:
        let
          part = diskConfig.content.partitions.${partName};
        in
        part.content.type or "" == "zfs" && part.content.pool or "" == poolName
      )
      (throw "No ZFS partition found for pool ${poolName}")
      (builtins.attrNames diskConfig.content.partitions);

  # Calculate partition number from position in attrset
  partNames = builtins.attrNames diskConfig.content.partitions;
  partIndex = lib.lists.findFirstIndex (n: n == zfsPartName) null partNames;
  partNumber = toString (partIndex + 1); # Partitions are 1-indexed

  devicePath = "${diskConfig.device}-part${partNumber}";

  # Construct device paths
  credstoreZvolPath = "/dev/zvol/${poolName}/${credstoreDatasetName}";
  credstoreMappedPath = "/dev/mapper/${credstoreLuksName}";
in
{
  assertions = [
    {
      assertion = builtins.length poolNames == 1;
      message = ''
        tpm-decrypt.nix: Expected exactly 1 zpool with credstore zvol.
        Found ${toString (builtins.length poolNames)}: ${lib.concatStringsSep ", " poolNames}

        A credstore is a zfs_volume with LUKS encryption that stores the ZFS key.
        Only one pool should have this structure.
      '';
    }
    {
      assertion = credstoreConfig.type == "zfs_volume";
      message = ''
        tpm-decrypt.nix: credstore must be type 'zfs_volume', found '${credstoreConfig.type}'.
        The credstore must be a zvol to appear as /dev/zvol/${poolName}/${credstoreDatasetName}.
      '';
    }
    {
      assertion = credstoreConfig.content.type == "luks";
      message = ''
        tpm-decrypt.nix: credstore must have LUKS encryption.
        Found content type: ${credstoreConfig.content.type or "none"}
      '';
    }
    {
      assertion = lib.hasPrefix "file://" keylocation;
      message = ''
        tpm-decrypt.nix: Encrypted dataset '${encryptedDatasetName}' has invalid keylocation.
        Found: ${keylocation}
        Expected: file:///<path>/<filename>

        The keylocation must be a file:// URI pointing to where the key will be stored.
        The credstore will be mounted at the directory portion of this path.
        Example: file:///etc/credstore/zfs-sysroot.mount
      '';
    }
  ];

  boot = {
    initrd = {
      systemd = {
        enable = true; # Required for custom boot ordering

        services = {
          # Disable default ZFS import service to use our custom bare import
          "zfs-import-${poolName}".enable = false;

          # Fix ordering: create-needed-for-boot-dirs needs to wait for key loading
          create-needed-for-boot-dirs = {
            after = [ "zfs-load-key-${poolName}.service" ];
            requires = [ "zfs-load-key-${poolName}.service" ];
          };

          # Critical: Configure udevd ordering (from discourse thread)
          # Ensures udevd completes before cryptsetup attempts to unlock
          # Prevents race where cryptsetup starts before device events settle
          systemd-udevd.before = [ "systemd-cryptsetup@${credstoreLuksName}.service" ];

          # Import pool bare (-N) to make zvols available before LUKS unlock
          "import-${poolName}-bare" =
            let
              # Properly escape device paths for systemd unit names
              devices = map (p: utils.escapeSystemdPath p + ".device") [
                devicePath
              ];
            in
            {
              description = "Import ${poolName} pool bare for credential zvol access";

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
                "systemd-cryptsetup@${credstoreLuksName}.service"
              ];
              conflicts = [ "initrd-switch-root.target" ];

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                # No ExecStop - pool must stay imported for running system
                # Real root (zroot/local/root) is on this pool
              };

              path = [ config.boot.zfs.package ];

              script = ''
                # Cleanup trap: If import or validation fails, attempt pool export
                # This prevents leaving the pool in a partially-imported bad state
                # Note: Pool stays imported on success (needed for real root)
                function cleanup() {
                  exit_code=$?
                  if [ "$exit_code" != 0 ]; then
                    echo "Import failed, attempting to export pool..." >&2
                    zpool export ${poolName} 2>/dev/null || true
                  fi
                }
                trap cleanup EXIT

                # Import without mounting (-N flag)
                # -N: Don't mount any datasets (makes zvols available as block devices)
                # -f: Force import (may show as in-use from install environment)
                zpool import -N -f ${poolName}

                # Security: Validate encryption root before proceeding
                encroot="$(zfs get -H -o value encryptionroot ${encryptedDataset})"
                if [ "$encroot" != "${encryptedDataset}" ]; then
                  echo "ERROR: ${encryptedDataset} has invalid encryptionroot $encroot" >&2
                  exit 1
                fi

                echo "Successfully imported ${poolName} pool (bare mode)"
              '';
            };
          # Load ZFS encryption key from TPM2-backed credential store
          "zfs-load-key-${poolName}" = {
            description = "Load ZFS encryption key from TPM2-backed credential store";

            unitConfig = {
              DefaultDependencies = false;
              RequiresMountsFor = credstoreMountpoint;
            };

            # Must wait for both pool import and credstore mount
            requires = [ "import-${poolName}-bare.service" ];
            after = [
              "import-${poolName}-bare.service"
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
              ImportCredential = credentialFileName;
            };

            path = [ config.boot.zfs.package ];

            script = ''
              # Load key from credential directory (automatically decrypted by systemd)
              zfs load-key -L file://"''${CREDENTIALS_DIRECTORY}"/${credentialFileName} ${encryptedDataset}
              echo "Successfully loaded ZFS encryption key"
            '';
          };
          # Rollback root filesystem to pristine state (impermanence)
          rollback = {
            description = "Rollback root filesystem to pristine state on boot";

            wantedBy = [ "initrd.target" ];

            # Must wait for ZFS key to be loaded
            requires = [ "zfs-load-key-${poolName}.service" ];
            after = [ "zfs-load-key-${poolName}.service" ];
            before = [ "sysroot.mount" ];

            path = [ config.boot.zfs.package ];

            unitConfig.DefaultDependencies = false;

            serviceConfig.Type = "oneshot";

            script = ''
              zfs rollback -r ${poolName}/${encryptedDatasetName}/root@blank && \
                echo "  >> >> rollback complete << <<"
            '';
          };
        };

        # Explicitly define credstore mount unit (not via fstab)
        mounts = [
          {
            where = credstoreMountpoint;
            what = credstoreMappedPath;
            type = "ext4";
            options = "defaults";
            wantedBy = [ "initrd-fs.target" ];
            after = [
              "systemd-cryptsetup@${credstoreLuksName}.service"
              "systemd-udevd.service" # After udev during startup, before udev during shutdown
            ];
            requires = [ "systemd-cryptsetup@${credstoreLuksName}.service" ];
            before = [ "initrd-switch-root.target" ];
            conflicts = [ "initrd-switch-root.target" ];
            unitConfig.DefaultDependencies = false;
          }
        ];
      };

      # Configure TPM2-backed LUKS device for credential store
      luks.devices.${credstoreLuksName} = {
        device = credstoreZvolPath;
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

    # ========================================================================
    # DEBUG OPTIONS (DANGEROUS - Only enable temporarily!)
    # ========================================================================
    #
    # WARNING: rd.systemd.debug_shell provides unauthenticated root access
    #          DELETE any signed lanzaboote stubs after debugging!
    #
    # kernelParams = [
    #   "systemd.log_level=debug"
    #   "systemd.log_target=console"
    # ];
    # initrd.systemd.emergencyAccess = true;
    #
    # Emergency shell available on tty9 (Ctrl+Alt+F9)
  };

  # Add TPM2 tools for manual enrollment and testing
  environment.systemPackages = with pkgs; [
    tpm2-tss
    tpm2-tools
  ];
}
