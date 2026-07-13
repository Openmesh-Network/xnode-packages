#!/usr/bin/env python3
"""
generate-flake.py <intel-oneapi-package-name>

Fetches the Intel oneAPI apt Packages index, resolves all intel-* dependencies
of the given package transitively, and writes:

  flake.nix   — one derivation per package, hashes set to lib.fakeHash

Each non-root package produces two Nix attrs:
  <attr>_raw   — mkDerivation that unpacks the deb
  <attr>       — symlinkJoin of <attr>_raw + its direct Intel deps (joined)

This means depending on <attr> gives you the package content AND all its
transitive Intel deps, mirroring how apt meta-packages work.

The root package produces only a symlinkJoin of its direct deps (no _raw,
since the meta-package deb itself contains nothing useful).
"""

import sys
import re
import gzip
import urllib.request
from collections import OrderedDict

PACKAGES_URL = "https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages.gz"
REPO_BASE    = "https://apt.repos.intel.com/oneapi"


def nix_attr(name):
    """Sanitize a Debian package name into a valid unquoted Nix identifier.
    Dots are not allowed in unquoted Nix attribute names, so replace with
    underscores. Hyphens are fine."""
    return re.sub(r"[^a-zA-Z0-9_\-]", "_", name)

# ── Packages index ────────────────────────────────────────────────────────────

def deb_version_key(version_str):
    """Sort key for Debian version strings (epoch:upstream-revision).
    Splits each part into (non-digit, digit) tuples for correct ordering,
    e.g. 2021.1.1 < 2026.0.0, 52 < 119."""
    epoch, _, rest = version_str.partition(":")
    if not _:
        epoch, rest = "0", epoch

    def split_part(s):
        return tuple(
            int(p) if p.isdigit() else p
            for p in re.split(r"(\d+)", s) if p
        )

    upstream, _, revision = rest.rpartition("-")
    return (int(epoch), split_part(upstream or rest), split_part(revision or "0"))


def fetch_packages():
    print("Fetching Intel apt Packages index …", file=sys.stderr)
    with urllib.request.urlopen(PACKAGES_URL) as r:
        raw = gzip.decompress(r.read()).decode()

    index = {}
    for stanza in raw.split("\n\n"):
        fields = {}
        cur_key = None
        for line in stanza.splitlines():
            if not line:
                continue
            if line[0] == " ":                      # RFC 822 continuation
                if cur_key:
                    fields[cur_key] += " " + line.strip()
            else:
                m = re.match(r"^([^:]+):\s*(.*)", line)
                if m:
                    cur_key, fields[cur_key] = m.group(1), m.group(2)
        if "Package" not in fields:
            continue
        name = fields["Package"]
        if name not in index:
            index[name] = fields
        else:
            # Keep whichever entry has the higher version
            existing_ver = index[name].get("Version", "0")
            new_ver      = fields.get("Version", "0")
            if deb_version_key(new_ver) > deb_version_key(existing_ver):
                index[name] = fields
    return index


def intel_deps(pkg_fields, index):
    """Direct intel-* deps that actually exist in the index."""
    deps = []
    for part in re.split(r",\s*", pkg_fields.get("Depends", "")):
        name = re.sub(r"\s*\(.*?\)", "", part).strip()
        if name.startswith("intel-") and name in index:
            deps.append(name)
    return deps


def topo_resolve(root, index):
    """Return all transitively reachable Intel packages in topo order (deps first)."""
    resolved = OrderedDict()

    def visit(name):
        if name in resolved or name not in index:
            return
        for dep in intel_deps(index[name], index):
            visit(dep)
        resolved[name] = index[name]

    visit(root)
    return resolved

# ── Nix generation ────────────────────────────────────────────────────────────

# Generic installPhase: finds and merges lib/share/include/bin at any depth
INSTALL_PHASE = """\
            mkdir -p "$out"
            while IFS= read -r -d "" dir && IFS= read -r -d "" found; do
              [ -d "$found" ] || continue
              mkdir -p "$out/$dir"
              cp -rT "$found" "$out/$dir/"
            done < <(
              find . -mindepth 2 -maxdepth 8 -type d \
                \( -name lib -o -name share -o -name include -o -name bin -o -name opt \) \
                -printf '%f\0%p\0' -prune
            )"""


def make_raw_drv(name, info, dep_names):
    """mkDerivation that unpacks the deb. Exposed as <attr>_raw.
    Intel deps (as their joined attrs) are in buildInputs so autoPatchelfHook
    can find transitive libraries at build time."""
    version  = info.get("Version", "unknown")
    filename = info.get("Filename", "")
    url      = f"{REPO_BASE}/{filename}"
    attr     = nix_attr(name)

    intel_bi = [nix_attr(d) for d in dep_names if d != name]
    bi_intel = "".join(f"\n          {d}" for d in intel_bi)
    bi_block = (
        f"[{bi_intel}\n"
        f"          # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)\n"
        f"        ]"
    )

    return "\n".join([
        f"      {attr}_raw = pkgs.stdenv.mkDerivation {{",
        f"        pname = \"{name}\";",
        f"        version = \"{version}\";",
        f"",
        f"        src = pkgs.fetchurl {{",
        f"          url = \"{url}\";",
        f"          hash = lib.fakeHash;",
        f"        }};",
        f"",
        f"        nativeBuildInputs = [",
        f"          pkgs.autoPatchelfHook",
        f"          pkgs.dpkg",
        f"        ];",
        f"",
        f"        buildInputs = {bi_block};",
        f"",
        f"        dontConfigure = true;",
        f"        dontBuild = true;",
        f"",
        f"        unpackPhase = \"dpkg -x $src ./\";",
        f"",
        f"        installPhase = ''",
        INSTALL_PHASE,
        f"        '';",
        f"      }};",
    ])


def make_joined_drv(name, dep_names):
    """symlinkJoin of <attr>_raw + direct Intel deps (their joined attrs).
    Depending on this gives you the package content AND all Intel deps."""
    attr      = nix_attr(name)
    dep_attrs = [nix_attr(d) for d in dep_names if d != name]
    path_list = [f"{attr}_raw"] + dep_attrs
    paths     = "\n".join(f"          {p}" for p in path_list)
    return "\n".join([
        f"      {attr} = pkgs.symlinkJoin {{",
        f"        name = \"{name}\";",
        f"        paths = [",
        paths,
        f"        ];",
        f"      }};",
    ])


def make_root_join(root, direct_dep_names):
    """Root meta-package: symlinkJoin of direct deps only.
    No _raw — the meta-package deb contains nothing; it only pulls in deps."""
    attr  = nix_attr(root)
    paths = "\n".join(f"          {nix_attr(d)}" for d in direct_dep_names if d != root)
    return "\n".join([
        f"      {attr} = pkgs.symlinkJoin {{",
        f"        name = \"{root}\";",
        f"        paths = [",
        paths,
        f"        ];",
        f"      }};",
    ])


def generate(root, all_pkgs, index):
    dep_map = {n: intel_deps(i, all_pkgs) for n, i in all_pkgs.items()}

    blocks = []
    for n in all_pkgs:
        if n == root:
            continue
        # Emit raw derivation and its symlinkJoin together for readability
        raw    = make_raw_drv(n, all_pkgs[n], dep_map[n])
        joined = make_joined_drv(n, dep_map[n])
        blocks.append(raw + "\n\n" + joined)

    blocks.append(make_root_join(root, dep_map[root]))
    drvs = "\n\n".join(blocks)

    flake = "\n".join([
        "{",
        f"  description = \"Intel oneAPI: {root} and its Intel dependencies\";",
        "",
        "  inputs.nixpkgs.url = \"github:NixOS/nixpkgs/nixos-unstable\";",
        "",
        "  outputs = { self, nixpkgs }: let",
        "    pkgs = nixpkgs.legacyPackages.x86_64-linux;",
        "    lib  = pkgs.lib;",
        "  in {",
        "    packages.x86_64-linux = rec {",
        "",
        drvs,
        "",
        f"      default = {nix_attr(root)};",
        "    };",
        "  };",
        "}",
        "",
    ])

    return flake

# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "intel-oneapi-toolkit"

    index = fetch_packages()

    if root not in index:
        sys.exit(
            f"Error: '{root}' not found in the Packages index.\n"
            f"Hint: try `curl -s '{PACKAGES_URL}' | zcat | grep '^Package: {root}'`"
        )

    print(f"Resolving dependencies for {root} …", file=sys.stderr)
    all_pkgs = topo_resolve(root, index)
    print(f"  → {len(all_pkgs)} Intel package(s) total (including {root})", file=sys.stderr)
    for n in all_pkgs:
        marker = " ← root" if n == root else ""
        print(f"      {n}{marker}", file=sys.stderr)

    flake = generate(root, all_pkgs, index)

    with open("flake.nix", "w") as f:
        f.write(flake)

    print("", file=sys.stderr)
    print("Written: flake.nix", file=sys.stderr)
    print("Next: ./fill-hashes.sh", file=sys.stderr)


if __name__ == "__main__":
    main()