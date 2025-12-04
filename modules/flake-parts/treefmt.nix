# Treefmt configuration for code formatting
{
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    flakeCheck = false; # Covered by git-hooks check
    programs = {
      nixfmt.enable = true;
      shfmt = {
        enable = true;
        indent_size = 0;
      };
    };
  };
}
