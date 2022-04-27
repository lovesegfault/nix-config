final: _: {
  ubootRaspberryPi4_64bit = final.buildUBoot rec {
    version = "2022.01";
    src = final.fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      hash = "sha256-gbRUMifbIowD+KG/XdvIE7C7j2VVzkYGTvchpvxoBBM=";
    };
    defconfig = "rpi_4_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
    extraConfig = ''
      CONFIG_CMD_NVME=y
      CONFIG_NVME=y
      CONFIG_NVME_PCI=y
      CONFIG_USB_EHCI_GENERIC=y
      CONFIG_USB_EHCI_HCD=y
      CONFIG_USB_FUNCTION_MASS_STORAGE=y
      CONFIG_USB_OHCI_HCD=y
      CONFIG_USB_STORAGE=y
      CONFIG_USB_XHCI_BRCM=y
    '';
    # These were taken from:
    # https://github.com/home-assistant/operating-system/tree/dev/buildroot-external/board/raspberrypi/patches/uboot
    # https://github.com/home-assistant/operating-system/tree/dev/buildroot-external/board/raspberrypi/yellow/patches/uboot
    extraPatches = [
      ./0001-rpi-add-NVMe-to-boot-order.patch
      ./0002-Revert-nvme-Correct-the-prps-per-page-calculation-me.patch
      ./0003-usb-xhci-brcm-Make-driver-compatible-with-downstream.patch
      ./0004-drivers-bcm283x-don-t-explicitly-disable-init.patch
      ./0005-drivers-bcm283x-allow-to-spawn-any-PL011-UART.patch
      ./0006-nvme-improve-readability-of-nvme_setup_prps.patch
      ./0007-nvme-Use-pointer-for-CPU-addressed-buffers.patch
      ./0008-nvme-translate-virtual-addresses-into-the-bus-s-addr.patch
    ];
  };
}
