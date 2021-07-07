{ pkgs, ... }: {
  imports = [ ./documentation.nix ];

  environment = {
    enableDebugInfo = true;
    systemPackages = with pkgs; [ git neovim tmate upterm ];
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0660", GROUP="dialout", TAG+="uaccess"
  '';
}
