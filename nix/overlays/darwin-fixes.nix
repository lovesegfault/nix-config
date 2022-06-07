_: prev: {
  python39 = prev.python39.override {
    packageOverrides = _: pyPrev: {
      questionary = pyPrev.questionary.overrideAttrs (old: {
        meta = old.meta // { broken = false; };
      });
    };
  };
}
