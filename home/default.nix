let
  homePkg = machine:
    (import <home-manager/home-manager/home-manager.nix> {
      confPath = machine;
      confAttr = "";
    }).activationPackage;
in { foucault = homePkg ./machines/foucault.nix; }
