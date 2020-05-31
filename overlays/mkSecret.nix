self: super:
with builtins; with self.lib;
{
  mkSecret = path:
    let
      name = baseNameOf (toString path);
      stub = toFile name "This is a stub!\n";
    in
    if pathExists path then path else self.lib.warn "Using stub for secrets/${name}" stub;
}
