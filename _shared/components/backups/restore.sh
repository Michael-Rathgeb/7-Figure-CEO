#!/usr/bin/env sh
# Agent Deployer restore: stop, set current data aside, unpack an archive, start.
set -eu
cd "$(dirname "$0")"
archive="${1:-}"
[ -f "$archive" ] || { echo "usage: ./restore.sh backups/backup-YYYYMMDD-HHMMSS.tar.gz"; exit 1; }
stamp="$(date +%Y%m%d-%H%M%S)"
docker compose stop
[ -d data ] && mv data "data.before-restore-${stamp}"
[ -f .env ] && cp .env ".env.before-restore-${stamp}" && chmod 600 ".env.before-restore-${stamp}"
tar -xzf "$archive"
chmod 600 .env
docker compose up -d
echo "restored from $archive. previous data kept at data.before-restore-${stamp}"
