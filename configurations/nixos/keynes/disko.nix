# zroot is striped across 6 io2 EBS volumes (durability tier). Instance-store
# NVMe is attached as L2ARC at boot by zpool-l2arc-ensure, never by disko:
# the devices are wiped on stop/start and carry fresh serials each time.
let
  zfsDisk = device: {
    type = "disk";
    inherit device;
    content = {
      type = "gpt";
      partitions.zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
  };
in
{
  fileSystems."/nix".neededForBoot = true;

  disko.devices = {
    disk = {
      ebs1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol06dfec82e16229fd0";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # BIOS boot partition; EC2 instance boots legacy BIOS
            };
            bootfs = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
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
      ebs2 = zfsDisk "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol0aa10846edf1314ab";
      ebs3 = zfsDisk "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol0f5a9ebeed2e69398";
      ebs4 = zfsDisk "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol0b9123c12dbdf04ed";
      ebs5 = zfsDisk "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol0734e7f824eea87e0";
      ebs6 = zfsDisk "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_vol015a3515357f32011";
    };

    zpool.zroot = {
      type = "zpool";
      # No mode set: all members become striped top-level vdevs.
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        compression = "zstd";
        mountpoint = "none";
        xattr = "sa";
        "com.sun:auto-snapshot" = "false";
      };
      options.ashift = "12";
      datasets = {
        root = rec {
          type = "zfs_fs";
          mountpoint = "/";
          options.mountpoint = mountpoint;
        };
        home = rec {
          type = "zfs_fs";
          mountpoint = "/home";
          options.mountpoint = mountpoint;
        };
        nix = rec {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            inherit mountpoint;
            # The store is reproducible by definition; don't pay ~0.6ms EBS
            # round-trips for sqlite fsyncs on every path registration.
            # Unclean-crash worst case: nix-store --verify --repair.
            sync = "disabled";
          };
        };
      };
    };
  };
}
