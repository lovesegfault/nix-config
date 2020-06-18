{ pkgs, ... }: {
  users.users.naser = {
    createHome = true;
    description = "Naser Derakhshan";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfY1bn6W5bWnc8YxBmgtXcbtGB0CSJWJlGLffmktsd2m6ZPtpUxswDpzSQSS2WyWBTuZSVXifGkwF2ELbroS+tqvfZ7TBUmXXIWp4TcQ73w3LYBinqaJ57hie8q209PnBlVa/q1Fo45oDTEY4D3X2CpdDHyNUFGWFB2wrjgJL+AeGfn+3bp4oO6m3h6ccxlO0gJ4Ql/qaw9sB1uq8tC8WLxBb0VwcYC5nPGs3rC/IlOz3ONDud+BUlUhen6DoZXLAuNA1PylW2cvh/ydImM7RhR9530m3kO2bZIQvkyI/qPQym/VY6w7p7QWU84ZxljGsAgHHsGKsAzhWnUQFRxvgoV9cd0dhMm084K1XSdVtToGWv7zaIxMx+txlhpQ40Im3ppFsHP77OfEopcdskaqSZZYuS0llDrPWhmyHuSAYBGRln+REX2TwsSn+fn1E8kgaLhpAr03u65rSlk5GVQB6BAKQL1CK+YqNNTFORgMEz90v28Xxu3QIFuy0CmeJ8ML7ALZHky1YgGj0gKPaxJc/LK2veJysMIhlQpZCk2YbwI3a4o3nrgnGDDC3EZvlo2fTT4rQRg6QUxrZSNf8/sAeqCyyFdY+NN6qvIHb7jeAbAasWvpyJYbOP/BQyZGVUw9J/DVSDVi/Y0Lo+m6giC9U2wpjfnHFo1hDvcUhXoOZ23w== naser@standard.ai"
    ];
  };
  home-manager.users.naser = {
    home.packages = with pkgs; [ hello ];
  };
}
