#!/usr/bin/env bash
# fill-hashes.sh — fill every lib.fakeHash in flake.nix with a real SRI hash.
# Reads fetchurl blocks directly from flake.nix; no .pkg-urls file needed.
# Requires: nix (modern, 2.19+), python3

set -euo pipefail

[[ -f flake.nix ]] || { echo "ERROR: flake.nix not found" >&2; exit 1; }

updated=0
skipped=0
failed=0

# Extract URLs from fetchurl blocks that still have lib.fakeHash
mapfile -t urls < <(python3 <<'PYEOF'
import re

content = open("flake.nix").read()

# Match fetchurl blocks where hash = lib.fakeHash
pat = re.compile(
    r'pkgs\.fetchurl\s*\{[^}]*?url\s*=\s*"([^"]+)"[^}]*?hash\s*=\s*lib\.fakeHash',
    re.DOTALL
)

seen = set()
for m in pat.finditer(content):
    url = m.group(1)
    if url not in seen:
        seen.add(url)
        print(url)
PYEOF
)

if [[ ${#urls[@]} -eq 0 ]]; then
    echo "No lib.fakeHash entries found — nothing to do."
    exit 0
fi

echo "Found ${#urls[@]} unfilled hash(es)."
echo ""

prefetch() {
    # Try the nix store/download cache first (instant if already fetched),
    # then fall back to a real network download.
    local url="$1"
    nix --offline store prefetch-file --json "$url" 2>/dev/null \
        || nix store prefetch-file --json "$url"
}

for url in "${urls[@]}"; do
    printf "  %s\n  → " "$url"

    sri=$(prefetch "$url" \
          | python3 -c "import sys,json; print(json.load(sys.stdin)['hash'])") || {
        echo "FAILED (download)"
        (( ++failed ))
        continue
    }

    # Replace the first remaining lib.fakeHash whose fetchurl url matches
    rc=0
    python3 - "$url" "$sri" <<'PYEOF' || rc=$?
import re, sys

url, sri = sys.argv[1], sys.argv[2]

with open("flake.nix") as f:
    content = f.read()

pat = re.compile(
    r'(pkgs\.fetchurl\s*\{[^}]*?url\s*=\s*"' + re.escape(url) + r'"[^}]*?hash\s*=\s*)lib\.fakeHash',
    re.DOTALL
)
new, n = pat.subn(rf'\1"{sri}"', content, count=1)
if n == 0:
    sys.exit(2)
with open("flake.nix", "w") as f:
    f.write(new)
PYEOF

    if   [[ $rc -eq 2 ]]; then echo "skip (already filled)"; (( ++skipped ))
    elif [[ $rc -ne 0 ]]; then echo "FAILED (patch)";        (( ++failed ))
    else                        echo "$sri";                  (( ++updated ))
    fi
done

echo ""
echo "Done: ${updated} updated, ${skipped} skipped, ${failed} failed."
[[ $failed -eq 0 ]] || { echo "Some packages failed — re-run to retry." >&2; exit 1; }