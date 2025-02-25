#!/usr/bin/env python3

import itertools
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Callable, Iterable, List, Optional, Self, Sequence

GITHUB_PLATFORMS = {
    "x86_64-linux": "ubuntu-24.04",
    "x86_64-darwin": "macos-13",
    "aarch64-darwin": "macos-15",
    "aarch64-linux": "ubuntu-22.04-arm",
}


def main():
    summary = Summary()
    summary.write("# CI")

    flake = Flake.from_hosts_file()

    if flake.evalOnly:
        evalNames = ",".join([a.name for a in flake.evalOnly])
        summary.write(
            f"- ⚠️ The following attributes will only be evaluated: {evalNames}"
        )
    if flake.buildables:
        buildNames = ",".join([a.name for a in flake.buildables])
        summary.write(f"- ✅ The following attributes will be built: {buildNames}")

    duplicates = find_duplicates_by(lambda x: x.attr, flake.all())
    if duplicates:
        duplicateAttrs = ",".join(duplicates)
        msg = f"- ‼️ Duplicate attributes found: {duplicateAttrs}"
        summary.write(msg)
        raise RuntimeError(msg)

    darwinHosts, buildables = partition(
        lambda drv: drv.isDarwinHost(), flake.buildables
    )

    output = Output()
    indent = 4 if output.is_stdout else None

    output.write_kv(
        "eval", json.dumps([o.__dict__ for o in flake.evalOnly], indent=indent)
    )
    output.write_kv(
        "build", json.dumps([o.__dict__ for o in buildables], indent=indent)
    )
    output.write_kv(
        "darwin-hosts", json.dumps([o.__dict__ for o in darwinHosts], indent=indent)
    )


def partition[T](
    pred: Callable[[T], bool], iterable: Iterable[T]
) -> tuple[Iterable[T], Iterable[T]]:
    t1, t2 = itertools.tee(iterable)
    return filter(pred, t2), itertools.filterfalse(pred, t1)


def find_duplicates_by[I, G](by: Callable[[I], G], iterable: Iterable[I]) -> List[G]:
    seen = set()
    dupes = []
    for i in iterable:
        grouped_by = by(i)
        if grouped_by in seen:
            dupes.append(grouped_by)
        else:
            seen.add(grouped_by)
    return dupes


class ActionsWriter:
    is_stdout: bool

    def __init__(self, outputFileEnvVar: str) -> None:
        if "GITHUB_ACTIONS" in os.environ:
            outputFile = os.environ.get(outputFileEnvVar)
            if outputFile is None:
                raise RuntimeError(f"did not find {outputFileEnvVar} in environment")
            self.file = open(outputFile, "a")
            self.is_stdout = False
        else:
            self.file = sys.stdout
            self.is_stdout = True

    def __exit__(self) -> None:
        self.file.close()

    def write(self, msg: str) -> None:
        self.file.write(f"{msg}\n")
        self.file.flush()


class Summary(ActionsWriter):
    def __init__(self) -> None:
        super().__init__("GITHUB_STEP_SUMMARY")


class Output(ActionsWriter):
    def __init__(self) -> None:
        super().__init__("GITHUB_OUTPUT")

    def write_kv(self, key: str, value: str) -> None:
        super().write(f"{key}={value}")


class Derivation:
    name: str
    hostPlatform: str

    attr: str
    buildable: bool
    runsOn: str

    equivalentLinuxPlatform: Optional[str] = None
    equivalentLinuxRunner: Optional[str] = None

    def __init__(
        self, name: str, hostPlatform: str, attr: str, large: bool = False
    ) -> None:
        self.name = name
        self.hostPlatform = hostPlatform
        self.attr = attr

        if self.hostPlatform in GITHUB_PLATFORMS:
            self.runsOn = GITHUB_PLATFORMS[self.hostPlatform]
            self.buildable = not large
        else:
            self.runsOn = GITHUB_PLATFORMS["x86_64-linux"]
            self.buildable = False

        if self.hostPlatform.endswith("darwin"):
            self.equivalentLinuxPlatform = self.hostPlatform.replace("darwin", "linux")
            self.equivalentLinuxRunner = GITHUB_PLATFORMS[self.equivalentLinuxPlatform]

    def toJSON(self) -> str:
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True)

    def isDarwinHost(self) -> bool:
        return isinstance(self, Host) and self.hostPlatform.endswith("darwin")


class DevShell(Derivation):
    def __init__(self, hostPlatform: str) -> None:
        name = "devShell"
        attr = f"devShells.{hostPlatform}.default.inputDerivation"
        super().__init__(name, hostPlatform, attr)


class Host(Derivation):
    linuxBuilderAttr: Optional[str] = None

    def __init__(self, name: str, hostPlatform: str, large: bool) -> None:
        attr = f"packages.{hostPlatform}.{name}"
        super().__init__(name, hostPlatform, attr, large)
        if self.isDarwinHost():
            self.linuxBuilderAttr = f"darwinConfigurations.{name}.config.nix.linux-builder.package.nixosConfig.system.build.toplevel"


class Flake:
    buildables: Sequence[Derivation]
    evalOnly: Sequence[Derivation]

    def __init__(self, hosts: List[Host]) -> None:
        devShells = [DevShell(p) for p in set([h.hostPlatform for h in hosts])]
        buildables, evalOnly = map(
            list, partition(lambda a: a.buildable, itertools.chain(hosts, devShells))
        )
        self.buildables = buildables
        self.evalOnly = evalOnly

    def all(self) -> Iterable[Derivation]:
        return itertools.chain(self.buildables, self.evalOnly)

    @classmethod
    def from_hosts_file(cls) -> Self:
        hosts_path = Flake.find_hosts_file()
        raw = subprocess.run(
            ["nix", "eval", "--json", "-f", hosts_path],
            capture_output=True,
            check=True,
            text=True,
        ).stdout
        parsed = json.loads(raw)
        hosts = []
        for name, cfg in parsed.items():
            hosts.append(Host(name, cfg["hostPlatform"], cfg["large"]))

        return cls(hosts)

    @staticmethod
    def find_hosts_file() -> Path:
        script_dir = Path(__file__).absolute().parent
        toplevel = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=script_dir,
            capture_output=True,
            check=True,
            text=True,
        )
        toplevel = Path(toplevel.stdout.strip())
        hosts_path = toplevel / "nix" / "hosts.nix"
        if not hosts_path.exists():
            raise RuntimeError(f"did not find host definition in {hosts_path}")
        return hosts_path


if __name__ == "__main__":
    main()
