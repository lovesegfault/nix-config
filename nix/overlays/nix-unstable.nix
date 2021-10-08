self: super: {
  nixUnstable = super.nixUnstable.overrideAttrs (_: {
    version = "2.5pre20211007";

    src = self.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "844dd901a7debe8b03ec93a7f717b6c4038dc572";
      sha256 = "sha256-fe1B4lXkS6/UfpO0rJHwLC06zhOPrdSh4s9PmQ1JgPo=";
    };
  });
}
