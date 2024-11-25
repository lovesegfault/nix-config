{
  boot.zfs.forceImportAll = true;

  fileSystems = {
    "/nix/state".neededForBoot = true;
    "/nix".neededForBoot = true;
    # "/mnt/emp-next".options = [ "nofail" ];
    # "/mnt/emp-staging".options = [ "nofail" ];
  };

  disko.devices =
    let
      rootSsd = idx: id: {
        type = "disk";
        device = "/dev/disk/by-id/${id}";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = if idx == 1 then "/boot" else "/boot-${builtins.toString idx}";
              };
            };
            swap = {
              size = "64G";
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
      dataHdd = id: {
        type = "disk";
        device = "/dev/disk/by-id/${id}";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zdata";
            };
          };
        };
      };
    in
    {
      disk = {
        # Root pool disks
        nvme-a = rootSsd 1 "nvme-eui.36344630528007600025384500000001";
        nvme-b = rootSsd 2 "nvme-eui.36344630528007570025384500000001";

        # Data pool disks
        hdd-a = dataHdd "wwn-0x5000c500e58c4c11";
        hdd-b = dataHdd "wwn-0x5000c500e58fb872";
        hdd-c = dataHdd "wwn-0x5000c500e4e9a2e5";
        hdd-d = dataHdd "wwn-0x5000c500e58c6f89";
        hdd-e = dataHdd "wwn-0x5000c500e58f3d74";
        hdd-f = dataHdd "wwn-0x5000c500e5904fef";
        hdd-g = dataHdd "wwn-0x5000c500e560298b";
        hdd-h = dataHdd "wwn-0x5000c500e58e8a93";
        hdd-i = dataHdd "wwn-0x5000c500e5822075";
        hdd-j = dataHdd "wwn-0x5000c500e58e19ca";
      };
      zpool = {
        zdata = {
          type = "zpool";
          mode = "raidz2";
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            mountpoint = "none";
            xattr = "sa";
            "com.sun:auto-snapshot" = "false";
          };
          datasets = {
            documents = {
              type = "zfs_fs";
              mountpoint = "/mnt/documents";
            };
            downloads = {
              type = "zfs_fs";
              mountpoint = "/mnt/downloads";
            };
            emp = {
              type = "zfs_fs";
              mountpoint = "/mnt/emp";
            };
            emp-next = {
              type = "zfs_fs";
              mountpoint = "/mnt/emp-next";
            };
            emp-staging = {
              type = "zfs_fs";
              mountpoint = "/mnt/emp-staging";
            };
            emp-watch = {
              type = "zfs_fs";
              mountpoint = "/mnt/emp-watch";
            };
            movies = {
              type = "zfs_fs";
              mountpoint = "/mnt/movies";
            };
            music = {
              type = "zfs_fs";
              mountpoint = "/mnt/music";
            };
            pictures = {
              type = "zfs_fs";
              mountpoint = "/mnt/pictures";
            };
            redacted = {
              type = "zfs_fs";
              mountpoint = "/mnt/redacted";
            };
            secret = {
              type = "zfs_fs";
              mountpoint = "/mnt/secret";
            };
            shows = {
              type = "zfs_fs";
              mountpoint = "/mnt/shows";
            };
          };
        };
        zroot = {
          type = "zpool";
          mode = "mirror";
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
              options.mountpoint = "none";
            };
            "local/state" = {
              type = "zfs_fs";
              mountpoint = "/nix/state";
              options."com.sun:auto-snapshot" = "true";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options."com.sun:auto-snapshot" = "false";
            };
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options."com.sun:auto-snapshot" = "false";
              postCreateHook = "zfs snapshot zroot/local/root@blank";
            };
          };
        };
      };
    };
}
