# Restore the agent

From `~/agents/<run>/` on the host.

1. `ls -la backups/` and pick the archive with the person.
2. `./restore.sh backups/backup-<stamp>.tar.gz`. Current data is renamed, never deleted.
3. `docker compose ps` healthy, then the person messages the agent.
4. When they are satisfied, ask before removing `data.before-restore-*` and `.env.before-restore-*`.

Check: the agent replies and remembers what the backup should contain.
