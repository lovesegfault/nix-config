self: super:
with builtins; with self.lib;
{
  mkSecret = { file, ... }@args:
    let
      stub = toFile (baseNameOf (toString file)) "This is a stub!";
      file =
        if pathExists args.file then
          args.file
        else
          self.lib.warn "Using stub for secrets/${name}" stub;
    in
    args // { inherit file; };
}
