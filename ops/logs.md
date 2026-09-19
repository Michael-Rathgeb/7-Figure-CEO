# Read the logs

From `~/agents/<run>/` on the host.

- Live: `docker compose logs -f --tail 100`
- One service: `docker compose logs -f hermes` or `docker compose logs -f openclaw-gateway`
- State: `docker compose ps`, `docker stats --no-stream`
- Hermes files: `data/logs/`
- OpenClaw health: `curl -fsS http://127.0.0.1:18789/readyz`; deeper: `docker compose run --rm openclaw-cli doctor`
- Mac autostart: `cat autostart/launchd.log`
- Disk: `du -sh data backups`

Redact tokens if a log line contains one before pasting it to the person. Check: the person can say in one sentence what the last error means.
