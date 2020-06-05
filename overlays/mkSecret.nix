self: super:
with builtins; with self.lib;
{
  mkSecret = { file, ... }@args:
  let
      fileName = baseNameOf (toString file);
      stub = toFile fileName "This is a stub!";
      file =
        if pathExists args.file then
          args.file
        else
          self.lib.warn "Using stub for secrets/${fileName}" stub;
    in
    args // { inherit file; };
}
