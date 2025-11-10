# TPM2-Based ZFS Auto-Unlock Setup for Hegel

This document describes the TPM2-based automatic ZFS unlocking implementation and provides post-installation instructions.

## Architecture Overview

The implementation uses a **credential store zvol** with TPM2-backed LUKS encryption to securely store the ZFS encryption key. This follows the pattern from the NixOS discourse thread on importing ZFS pools before LUKS unlock.

### Boot Sequence

```
1. modprobe@zfs.service           # Load ZFS kernel module
         ↓
2. import-zroot-bare.service      # zpool import -N zroot (bare mode)
         ↓
3. cryptsetup-pre.target          # Synchronization point
         ↓
4. systemd-cryptsetup@credstore   # TPM2 auto-unlock LUKS zvol
         ↓
5. etc-credstore.mount            # Mount credential filesystem
         ↓
6. zfs-load-key-zroot.service     # Load ZFS key from credstore
         ↓
7. rollback.service               # Impermanence rollback
         ↓
8. sysroot.mount                  # Mount root filesystem
```

### Key Components

1. **`credstore` zvol**: 100M unencrypted ZFS volume with LUKS encryption containing the ZFS key
2. **TPM2 binding**: LUKS volume sealed to PCR 7 (Secure Boot state)
3. **Systemd credentials**: Secure key injection using `ImportCredential`
4. **Bare pool import**: Using `zpool import -N` to make zvols available before mounting

## Files Modified

- **`hosts/hegel/boot.nix`** (new): Systemd initrd services for TPM2 unlocking
- **`hosts/hegel/disko.nix`**: Added credstore zvol, changed encryption to raw key format
- **`hosts/hegel/default.nix`**: Import boot.nix, removed duplicate rollback service

## Post-Installation Steps

### 1. Verify TPM2 Hardware

After first boot, verify TPM2 is available:

```bash
# Check TPM device exists
ls -la /dev/tpm*
# Should show: /dev/tpm0 and/or /dev/tpmrm0

# Check TPM2 capabilities
tpm2_getcap properties-fixed
```

### 2. Enroll TPM2 Key for LUKS

The credstore LUKS volume currently requires a passphrase. Enroll TPM2 for automatic unlock:

```bash
# Add TPM2 key to LUKS keyslot (will prompt for existing passphrase)
sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
  --tpm2-device=auto \
  --tpm2-pcrs=7

# Verify enrollment
sudo cryptsetup luksDump /dev/zvol/zroot/credstore
# Should show a systemd-tpm2 token
```

### 3. Test Automatic Unlock

Reboot the system:

```bash
sudo reboot
```

The system should:
- Automatically unlock the credstore via TPM2
- Load the ZFS encryption key from credstore
- Mount the root filesystem without manual intervention
- Complete the impermanence rollback
- Boot to login prompt

### 4. Verify Boot Logs

Check that all services started successfully:

```bash
# Check import-zroot-bare service
sudo journalctl -u import-zroot-bare.service

# Check TPM2 LUKS unlock
sudo journalctl -u systemd-cryptsetup@credstore.service

# Check ZFS key loading
sudo journalctl -u zfs-load-key-zroot.service

# Check rollback
sudo journalctl -u rollback.service
```

All services should show successful completion.

## Fallback to Manual Unlock

If TPM2 unlock fails (firmware update, Secure Boot disabled, TPM failure), the system will prompt for the LUKS passphrase:

```
Please enter passphrase for disk zvol/zroot/credstore:
```

Enter the passphrase you set during installation. The boot will continue normally.

## Re-Enrollment After Updates

### When to Re-Enroll

TPM2 unlock may fail after:
- Firmware/BIOS updates
- Secure Boot policy changes
- Changes to PCR measurements

### How to Re-Enroll

If automatic unlock stops working:

1. Boot with manual passphrase entry
2. Re-enroll TPM2:
   ```bash
   # Remove old TPM2 token
   sudo systemd-cryptenroll /dev/zvol/zroot/credstore --wipe-slot=tpm2

   # Add new TPM2 token with current PCR state
   sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
     --tpm2-device=auto \
     --tpm2-pcrs=7
   ```
3. Reboot to test

## Advanced Configuration

### Stricter PCR Policy

For enhanced security, bind to more PCRs:

```bash
sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
  --tpm2-device=auto \
  --tpm2-pcrs=0,2,7,12
```

**PCRs:**
- **0**: Firmware code
- **2**: Boot applications (UEFI)
- **7**: Secure Boot state
- **12**: Kernel command line

**Trade-off**: Kernel updates will require re-enrollment.

### Add PIN Requirement

Require both TPM2 + PIN for unlock:

```bash
sudo systemd-cryptenroll /dev/zvol/zroot/credstore \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  --tpm2-with-pin=yes
```

Edit `/root/src/nix-config/hosts/hegel/boot.nix`:
```nix
crypttabExtraOpts = [
  "tpm2-device=auto"
  "tpm2-measure-pcr=yes"
  "tpm2-pcrs=7"
  "tpm2-pin=yes"  # Add this line
];
```

### Debug Boot Issues

Enable verbose logging in `/root/src/nix-config/hosts/hegel/boot.nix`:

```nix
boot.kernelParams = [
  "rd.systemd.log_level=debug"
  "rd.systemd.debug_shell"
];
boot.initrd.systemd.emergencyAccess = true;
```

Emergency shell will be available on **tty9** (Ctrl+Alt+F9).

## Security Considerations

### What TPM2 Protects Against

- **Offline disk theft**: Key sealed to specific hardware
- **Boot tampering**: PCR measurements verify boot chain integrity
- **Evil maid attacks**: Changes to boot process prevent unlock

### What TPM2 Does NOT Protect Against

- **Running system compromise**: Key already unsealed in memory
- **Physical hardware attacks**: TPM can be attacked with physical access
- **Cold boot attacks**: Memory may retain keys briefly after power off

### Best Practices

1. **Always maintain passphrase access**: Don't forget the LUKS passphrase
2. **Document passphrase securely**: Store in password manager
3. **Test fallback regularly**: Verify passphrase still works
4. **Re-enroll after updates**: Be aware when TPM state changes
5. **Physical security**: TPM2 complements but doesn't replace physical security

## Troubleshooting

### System Won't Boot

**Symptom**: System hangs at "Waiting for credstore unlock"

**Solution**:
1. Enter LUKS passphrase when prompted
2. After boot, check logs: `journalctl -u systemd-cryptsetup@credstore.service`
3. Re-enroll TPM2 if needed

### ZFS Key Load Fails

**Symptom**: Error "cannot load key for zroot/local"

**Solution**:
1. Boot into emergency shell (tty9)
2. Check credstore is mounted: `mount | grep credstore`
3. Check key file exists: `ls -la /etc/credstore/zfs-sysroot.mount`
4. Manually load key: `zfs load-key -L file:///etc/credstore/zfs-sysroot.mount zroot/local`

### Rollback Service Fails

**Symptom**: Rollback service shows failure

**Solution**:
1. Check ZFS key was loaded: `zfs get keystatus zroot/local`
2. Check snapshot exists: `zfs list -t snapshot zroot/local/root@blank`
3. Manually rollback: `zfs rollback -r zroot/local/root@blank`

## References

- [NixOS Discourse: Import ZPool Before LUKS](https://discourse.nixos.org/t/import-zpool-before-luks-with-systemd-on-boot/65400)
- [systemd-cryptenroll documentation](https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html)
- [TPM2 PCR Values](https://www.rfc-editor.org/rfc/rfc9472.html#name-registry-of-pcr-values)
- [ZFS Native Encryption](https://openzfs.github.io/openzfs-docs/man/master/8/zfs-load-key.8.html)

## Support

For issues specific to this configuration, check:
1. Boot logs: `journalctl -b -u "*.service"`
2. TPM2 state: `tpm2_getcap properties-variable`
3. ZFS status: `zpool status -v zroot`
4. LUKS status: `cryptsetup status credstore`
