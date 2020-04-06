self: super: {
  chromium = super.chromium.override {
    enableWideVine = true;
    useVaapi = true;
    useOzone = true;
  };
}
