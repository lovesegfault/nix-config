{ writeText, hosts }:
writeText "hosts.json" (builtins.toJSON ({ "hosts" = hosts; }))
