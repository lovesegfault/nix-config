# Pre-commit hooks configuration
{
  perSystem.pre-commit = {
    check.enable = true;
    settings.hooks = {
      actionlint.enable = true;
      deadnix.enable = true;
      nil.enable = true;
      shellcheck.enable = true;
      statix.enable = true;
      treefmt.enable = true;
    };
  };
}
