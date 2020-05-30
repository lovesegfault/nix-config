{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virt-manager spice-gtk ];
  security.polkit.enable = true;
  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
}
