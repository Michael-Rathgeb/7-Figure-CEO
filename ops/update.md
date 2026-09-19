# Update the agent

From `~/agents/<run>/` on the host. `pull_policy: always` means `up -d` pulls the newest image, so an update is one restart.

1. Back up first: `./backup.sh`
2. Note the current digest: `docker compose images`
3. `docker compose pull && docker compose up -d`
4. `docker compose ps` — everything `running` / `healthy` within a minute.
5. `docker compose logs --tail 50` — no migration errors.
6. OpenClaw only, if the logs mention config migration: `docker compose run --rm openclaw-cli doctor --fix`.
7. New digest: `docker compose images`. If unchanged, there was no new image; say so.

Check: the person sends the agent a message and gets a reply. If the update broke something, `ops/restore.md` with the archive from step 1.
