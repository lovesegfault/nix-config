#!/usr/bin/env python3

import dataclasses
import itertools
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import List, Self

IN_GITHUB_ACTIONS = "GITHUB_ACTIONS" in os.environ

GITHUB_PLATFORMS = {
    "x86_64-linux": "ubuntu-latest",
    "x86_64-darwin": "macos-13",
    "aarch64-darwin": "macos-latest",
}


def main():
    summary = Summary()
    summary.write("# CI")

    hosts = parse_hosts_file()
    devShells = [
        DevShell.from_platform(p) for p in set([h.hostPlatform for h in hosts])
    ]

    evalOnlyAttrs = [x for x in itertools.chain(hosts, devShells) if x.evalOnly]
    if evalOnlyAttrs:
        evalNames = [a.name for a in evalOnlyAttrs]
        summary.write(
            f"- ⚠️ The following attributes will only be evaluated: {','.join(evalNames)}"
        )

    buildAttrs = [x for x in itertools.chain(hosts, devShells) if not x.evalOnly]
    if buildAttrs:
        buildNames = [a.name for a in buildAttrs]
        summary.write(
            f"- ✅ The following attributes will be built: {','.join(buildNames)}"
        )

    # check for duplicates
    seen = set()
    dupes = []
    for x in itertools.chain(evalOnlyAttrs, buildAttrs):
        if x.attr in seen:
            dupes.append(x.attr)
        else:
            seen.add(x.attr)
    if dupes:
        msg = f"- ‼️ Duplicate attributes found: {','.join(dupes)}"
        summary.write(msg)
        raise RuntimeError(msg)

    output = Output()

    def json_list(attrList) -> str:
        return json.dumps([dataclasses.asdict(x) for x in attrList])

    output.write("build", json_list(buildAttrs))
    output.write("eval", json_list(evalOnlyAttrs))


class Summary:
    def __init__(self) -> None:
        if IN_GITHUB_ACTIONS:
            summaryFile = os.environ.get("GITHUB_STEP_SUMMARY")
            if summaryFile is None:
                raise RuntimeError("did not find GITHUB_STEP_SUMMARY in environment")
            self.file = open(summaryFile, "a")
        else:
            self.file = sys.stdout

    def __exit__(self) -> None:
        self.file.close()

    def write(self, msg: str) -> None:
        self.file.write(f"{msg}\n")
        self.file.flush()


class Output:
    def __init__(self) -> None:
        if IN_GITHUB_ACTIONS:
            outputFile = os.environ.get("GITHUB_OUTPUT")
            if outputFile is None:
                raise RuntimeError("did not find GITHUB_OUTPUT in environment")
            self.file = open(outputFile, "a")
        else:
            self.file = sys.stdout

    def __exit__(self) -> None:
        self.file.close()

    def write(self, key: str, data: str) -> None:
        self.file.write(f"{key}={data}\n")
        self.file.flush()

    pass


@dataclasses.dataclass()
class DevShell:
    name: str
    attr: str
    evalOnly: bool
    runsOn: str

    @classmethod
    def from_platform(cls, hostPlatform: str) -> Self:
        name = f"devShell-{hostPlatform}"
        attr = f"devShells.{hostPlatform}.default.inputDerivation"
        if hostPlatform in GITHUB_PLATFORMS:
            evalOnly = False
            runsOn = GITHUB_PLATFORMS[hostPlatform]
        else:
            evalOnly = True
            runsOn = "ubuntu-latest"
        return cls(name, attr, evalOnly, runsOn)


@dataclasses.dataclass()
class HostConfig:
    name: str
    kind: str
    hostPlatform: str
    large: bool
    address: str | None = None
    pubkey: str | None = None
    remoteBuild: bool = False
    homeDirectory: str | None = None

    evalOnly: bool = False
    runsOn: str = "ubuntu-latest"
    attr: str = "."

    @classmethod
    def from_json(cls, name: str, data: dict) -> Self:
        data["kind"] = data.pop("type")
        data["name"] = name
        cfg = cls(**data)

        if cfg.large:
            cfg.evalOnly = True

        if cfg.hostPlatform in GITHUB_PLATFORMS:
            cfg.runsOn = GITHUB_PLATFORMS[cfg.hostPlatform]
        else:
            cfg.evalOnly = True

        cfg.attr = f"packages.{cfg.hostPlatform}.{cfg.name}"

        return cfg


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


def parse_hosts_file() -> List[HostConfig]:
    hosts_path = find_hosts_file()
    raw = subprocess.run(
        ["nix", "eval", "--json", "-f", hosts_path],
        capture_output=True,
        check=True,
        text=True,
    ).stdout
    parsed = json.loads(raw)
    return [HostConfig.from_json(name, config) for name, config in parsed.items()]


if __name__ == "__main__":
    main()
