{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "oldceeleldhonbafppcapldpdifcinji"; } # Language Tool
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsor Block
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # Refined GitHub
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentraleyes
      { id = "fjdmkanbdloodhegphphhklnjfngoffa"; } # YouTube Auto HD
    ];
  };
}
