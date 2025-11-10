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
          "local" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              #keylocation = "file:///tmp/secret.key";
              keylocation = "prompt";
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
