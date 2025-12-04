# Pre-commit hooks configuration
_: {
  perSystem = _: {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
        actionlint.enable = true;
        nil.enable = true;
        shellcheck.enable = true;
        statix.enable = true;
        treefmt.enable = true;
      };
    };
  };
}
