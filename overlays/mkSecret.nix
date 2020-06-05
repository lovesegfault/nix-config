self: super:
with builtins; with self.lib;
{
  mkSecret = { file, ... }@args:
    let
      fileName = baseNameOf (toString file);
      stub = self.lib.warn "Using stub for secrets/${fileName}" (toFile fileName "stub");
      fileOrStub = if pathExists file then file else stub;
    in
    args // { file = fileOrStub; };
}
