# Back up the agent

From `~/agents/<run>/` on the host: `./backup.sh`. It pauses the containers for a few seconds, archives `data/` and `.env`, unpauses, keeps the last 14.

Check: `ls -la backups/` shows the new archive. Remind the person: `backups/` lives on the same disk. Copy the newest archive somewhere else (`scp`, iCloud folder, object storage) for a real backup. The archive holds their API keys; it is mode 600 and should stay private.
