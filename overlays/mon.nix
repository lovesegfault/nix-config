self: super: {
  mon =
    let
      lspci = "${self.pciutils}/bin/lspci";
      swaymsg = "${self.sway}/bin/swaymsg";
    in
    super.writeScriptBin "mon" ''
      #!${self.stdenv.shell}
      set -o xtrace
      # first we probe pci devices to wake up the nvidia gpu
      ${lspci}
      # now that it's been found we force sway to restart the displays, as
      # something usually goes wrong in the hotplug
      swaymsg "output * dpms off"
      sleep 0.5s
      swaymsg "output * dpms on"
    '';
}
