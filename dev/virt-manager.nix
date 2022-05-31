{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virt-manager spice-gtk swtpm ];
  security.polkit.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = with pkgs; [ OVMFFull ];
        };
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
