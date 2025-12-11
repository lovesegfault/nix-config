{
  fileSystems = {
    "/nix/state".neededForBoot = true;
    "/nix".neededForBoot = true;
  };

  disko.devices = {
    disk = {
      rootSSD = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_9100_PRO_2TB_S7YCNJ0Y506219W";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "192G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          mountpoint = "none";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options.ashift = "12";
        datasets = {
          # Credential store zvol: unencrypted zvol with TPM2-backed LUKS
          # Contains the raw encryption key for zroot/local
          credstore = {
            type = "zfs_volume";
            size = "100M";
            content = {
              type = "luks";
              name = "credstore";
              settings = {
                # No passwordFile - disko-install will prompt interactively
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                # Not mounted in main system, only in initrd
                # Hook runs after filesystem is formatted, before next dataset
                postCreateHook = ''
                  echo "==> Setting up ZFS encryption key in credential store..."

                  # credstore is already unlocked and formatted at this point
                  # Mount at /etc/credstore to match runtime path in boot.nix
                  mkdir -p /etc/credstore
                  mount /dev/mapper/credstore /etc/credstore

                  # Generate 256-bit random key for ZFS encryption
                  head -c 32 /dev/urandom > /etc/credstore/zfs-sysroot.mount
                  chmod 600 /etc/credstore/zfs-sysroot.mount

                  echo "==> Created ZFS encryption key: /etc/credstore/zfs-sysroot.mount"
                  echo "==> This key will be used to unlock zroot/local"

                  # Leave it mounted so the key is accessible when creating encrypted datasets
                  # disko will handle cleanup
                '';
              };
            };
          };

          # Encrypted parent dataset (key stored in credstore)
          "local" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "raw"; # Changed from passphrase to raw key
              keylocation = "file:///etc/credstore/zfs-sysroot.mount"; # Key from credstore
            };
          };
          "local/state" = rec {
            type = "zfs_fs";
            mountpoint = "/nix/state";
            options.mountpoint = mountpoint;
            options."com.sun:auto-snapshot" = "true";
          };
          "local/nix" = rec {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = mountpoint;
            options."com.sun:auto-snapshot" = "false";
          };
          "local/root" = rec {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = mountpoint;
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zroot/local/root@blank";
          };
        };
      };
    };
  };
}
