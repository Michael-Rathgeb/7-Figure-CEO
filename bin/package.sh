#!/usr/bin/env sh
# Build a clean, shareable copy of this workspace: the method only.
# Excludes every run's output (answers, logs, reports, assembled stacks, secrets), git metadata, and OS noise.
# Usage: bin/package.sh [out-dir]   → <out-dir>/agent-deployer-YYYYMMDD.zip
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-$HOME/Desktop}"
stamp="$(date +%Y%m%d)"
tmp="$(mktemp -d)"
name="agent-deployer-$stamp"
mkdir -p "$tmp/$name" "$out"
rsync -a \
  --exclude 'stages/*/output/*' --exclude 'your-agent.md' \
  --exclude '.git' --exclude '.DS_Store' --exclude '*.bak*' \
  "$here/" "$tmp/$name/"
# keep the empty output folders so the pipeline has somewhere to write
for s in "$tmp/$name"/stages/*/; do mkdir -p "$s/output"; touch "$s/output/.gitkeep"; done
# safety: refuse to ship anything that looks like a secret
if grep -rIlE '^[A-Z_]*(TOKEN|KEY|PASSWORD)=[^C$<]' "$tmp/$name" --include='*.env*' --include='*.md' 2>/dev/null | grep -v 'env.example' ; then
  echo "refusing to package: the files above contain filled secrets"; rm -rf "$tmp"; exit 1
fi
( cd "$tmp" && zip -qr "$out/$name.zip" "$name" )
rm -rf "$tmp"
echo "wrote $out/$name.zip ($(du -h "$out/$name.zip" | cut -f1))"
