{ pkgs, ... }: {
  users.users.allister = {
    createHome = true;
    description = "Allister Lindamood";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/PyIqp9omFbnT9mpxvEgeBc518gwlT2LEXIrm1QnVTY2ah+fbw95COtW+G26otQKuZW2+Z3tt4n1OkrGgZNbPAasym2h2Yo159OaIvrs9ePncGgmL0/ictnHuR9q131hTPGWsLdsUaxlXbCIMyAErgYkXN9LP4ULFtt72VZCmqqxQ64kXSTkBvfk9tPdrqgeEM9EXcGYds9ez+WqwKUKtAwiQGi51UNosnpQg6uQOdvMH3t3HbGhulIKNOcASprbg76dZab+hV80IWCBRXhgWy/nvogEiATK5uU5LplYEMz0DmWWqIlJT0w3xyFLnbs+MMJxf5JKwE7BsywEM4L1tCtMtLzh6VoIA3T7O7MczdU2knsuhX99XawlJs9IG0LzzSCzNns3GNjzjkLsJ/uZuPZZo+FvKouE8+aly1AYK8ajDWMKo4LrL629roXTMN0pWSC/wCOVdBQ+sZopFMIBGFVcnm9LAdxWadhjiL1uoqMbliXEZebnOylkB4Ii0cgHsO38mFwGNDO7iWmtw5uVM8FKENwZOCH69SQRcMn/Ikw4Be8GM14tvPVDz/O22xwJXFI/bLQlLZU0ckZEiIRwa22KEAGu8hHVewmwZpSLvLMcfn/ij+KTiI4/Cs1wRntYPe16ZWLKfTQuf1/vErtLBD/yzEGZUXS98HJfAWXIGvw== allister@standard.ai"
    ];
  };
  home-manager.users.allister = {
    home.packages = with pkgs; [ ];
  };
}
