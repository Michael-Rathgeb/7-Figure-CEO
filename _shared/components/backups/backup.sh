#!/usr/bin/env sh
# Agent Deployer backup: archive data/ and .env into backups/, keep the last 14.
set -eu
cd "$(dirname "$0")"
mkdir -p backups
stamp="$(date +%Y%m%d-%H%M%S)"
out="backups/backup-${stamp}.tar.gz"
# Pause writes briefly for a consistent copy. Containers restart in seconds.
docker compose pause >/dev/null 2>&1 || true
tar -czf "$out" data .env 2>/dev/null || { docker compose unpause >/dev/null 2>&1 || true; echo "backup failed"; exit 1; }
docker compose unpause >/dev/null 2>&1 || true
chmod 600 "$out"
# Keep the newest 14.
ls -1t backups/backup-*.tar.gz 2>/dev/null | tail -n +15 | xargs -r rm -f
echo "wrote $out ($(du -h "$out" | cut -f1))"
