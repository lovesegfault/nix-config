# Treefmt configuration for code formatting
_: {
  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";
      flakeCheck = false; # Covered by git-hooks check
      programs = {
        nixfmt.enable = true;
        ruff-format.enable = true;
        shfmt = {
          enable = true;
          indent_size = 0;
        };
      };
    };
  };
}
